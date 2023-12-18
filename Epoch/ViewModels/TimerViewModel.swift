//
//  TimerViewModel.swift
//  Epoch
//
//  Created by Justin Arnold on 12/16/23.
//

import Foundation
import UserNotifications


class TimerViewModel: ObservableObject {
    // Publish changes to the view
    @Published var timeRemaining: Int
    @Published var isActive: Bool = false

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
                pauseTimer()
            }
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
