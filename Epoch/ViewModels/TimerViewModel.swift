//
//  TimerViewModel.swift
//  Epoch
//
//  Created by Justin Arnold on 12/16/23.
//

import Foundation
import AVFoundation
import UserNotifications
import ActivityKit
import WidgetKit


class TimerViewModel: ObservableObject {
    // Publish changes to the view
    @Published var timeRemaining: Int
    @Published var isActive: Bool = false
    private var audioPlayer: AVAudioPlayer?
    private var activity: Activity<TimerWidgetAttributes>?

    private var baseTimeInSeconds: Int = 0
    private var startTime: Date?
    private var timer: Timer?

    init() {
        self.timeRemaining = baseTimeInSeconds
    }

    func startTimer() {
        startTime = Date()
        isActive = true
        scheduleNotification()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
        
        let contentState = TimerWidgetAttributes.ContentState(time: "5:00")
        let attributes = TimerWidgetAttributes(sessionName: "Test", sessionCount: 2)
        
        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil),
                pushType: nil
            )
            
            print("Activity starts:")
            
            
            /*startUpdates*/()
        } catch (let error) {
            print("Error starting Live Activity: \(error.localizedDescription).")
        }
    }

    func pauseTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            timeRemaining -= Int(elapsedTime)
        }
        startTime = nil
    }

    func resetTimer() {
        pauseTimer()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Cancel the notification
        timeRemaining = baseTimeInSeconds
    }
        
    func setBaseTime(_ baseTimeInSeconds: Int) {
        self.baseTimeInSeconds = baseTimeInSeconds
        self.timeRemaining = baseTimeInSeconds
    }

    func updateRemainingTime() {
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            timeRemaining = max(baseTimeInSeconds - Int(elapsedTime), 0)
            if timeRemaining <= 0 {
                timeRemaining = 0
                let soundName = UserDefaults.standard.string(forKey: "selectedAlarmSound") ?? "default"
                playSound(soundName: soundName)
                pauseTimer()
            }
        }
    }
    
    func playSound(soundName: String) {
        // Directly use the file name without any string manipulation
        let soundNameWithoutExtension = soundName.components(separatedBy: ".wav").first ?? soundName

        // Attempt to construct the URL for the sound file
        guard let url = Bundle.main.url(forResource: soundNameWithoutExtension, withExtension: "wav", subdirectory: "Alarms") else {
            print("Could not find the Library/Sounds directory.")
            return
        }

        print("URL for sound file: \(url)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error setting up audio session or playing sound: \(error)")
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Done!"
        content.body = "Your timer is up!"

        // Retrieve the selected alarm sound from UserDefaults
        let soundName = UserDefaults.standard.string(forKey: "selectedAlarmSound") ?? "default"
        print("Selected sound name from UserDefaults: \(soundName)")
        let sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).wav"))
        content.sound = sound
        print("Sound set for notification: \(String(describing: sound))")
        
        // Ensure the sound file exists
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav", subdirectory: "Alarms") {
            print("Sound file URL: \(soundURL)")
        } else {
            print("Sound file not found in the bundle. Falling back to default sound.")
            content.sound = UNNotificationSound.default
        }

        // Configure the trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeRemaining), repeats: false)
        print("Notification will be triggered in \(TimeInterval(timeRemaining)) seconds")

        // Create the request object.
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        print("Notification request created with identifier: \(request.identifier)")

        // Schedule the request.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error: Error?) in
            if let theError = error {
                print("Error scheduling notification: \(theError.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}
