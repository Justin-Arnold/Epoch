//
//  TimerView.swift
//  Epoch
//
//  Created by Justin Arnold on 9/15/23.
//

import SwiftUI
import AVFoundation

struct TimerView: View {
    // Constant Data
    let baseTime = 1500
  
    // Stateful Data
    @State var timerIsPaused = true
    @State private var timeRemaining: Int
    @State var timer: Timer? = nil
    @State private var player: AVAudioPlayer? = nil
    @State private var isNotificationPermissionGranted: Bool = false
    @State private var dragOffset: CGFloat = 0.0
    
    // Computed Data
    var timerIsFinished: Bool {
        return timeRemaining == 0
    }
    
    init() {
        timeRemaining = self.baseTime
    }
    
    func restartTimer() {
        timeRemaining = self.baseTime
    };
    
    func formatToDoubleDigit(_ number: Int) -> String {
        if number < 10 { return "0\(number)" }
        return "\(number)"
    };
    
    func secondsToTime(sec: Int) -> String {
        let minutesFromSec = sec / 60
        let remainingSec = sec % 60
        
        return "\(minutesFromSec):\(formatToDoubleDigit(remainingSec))"
    };
  
    var body: some View {
        VStack() {
            TimerCircle()
            Spacer();
            ZStack {
                RoundedRectangle(cornerRadius: 44)
                    .aspectRatio(3.0, contentMode: .fit)
                    .padding(8)
                    .shadow(radius: 4.0)
                if timerIsPaused {
                    HStack {
                        if timerIsFinished {
                            RestartButton()
                        } else {
                            StartButton()
                            RestartButton()
                        }
                    }
                } else {
                    StopButton()
                }
            }
        }.gesture(DragGesture()
            .onChanged{ gestureValue in
                self.dragOffset = gestureValue.translation.height
                self.timeRemaining -= Int(self.dragOffset / 10)
                self.timeRemaining -= Int(self.dragOffset / 10)
                self.timeRemaining = max(self.timeRemaining, 0)
            }
            .onEnded{ _ in
                self.dragOffset = 0.0
            }
        )
    }

    
    
    func StartButton() -> some View {
        return Button(action: {self.startTimer()}) {
            Label("play", systemImage: "play.fill")
        }.buttonStyle(.borderedProminent).controlSize(.large)
    }
    
    func StopButton() -> some View {
        return Button(action: {self.stopTimer()}) {
            Label("stop", systemImage: "stop.fill")
        }.buttonStyle(.borderedProminent).controlSize(.large)
    }
    
    func RestartButton() -> some View {
        return Button(action: {self.restartTimer()}) {
            Label("", systemImage: "backward.end.alt")
        }.controlSize(.mini).padding(4)
    }
    
    func TimerCircle() -> some View {
        VStack {
            Spacer()
            Text("\(secondsToTime(sec: timeRemaining))")
                .foregroundColor(Color.white)
                .font(.system(size: 80, weight: .bold, design: .serif))
            Spacer()
        }
    }
    
    private func checkNotificationPermission() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized, .provisional:
                        isNotificationPermissionGranted = true
                    default:
                        isNotificationPermissionGranted = false
                    }
                }
            }
        }
    
    func playTimerSound() {
        guard let url = Bundle.main.url(forResource: "jingle", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.prepareToPlay()
            self.player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
  
  func startTimer(){
    timerIsPaused = false
      if timeRemaining == 0 {
         restartTimer()
      }
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
        timeRemaining -= 1
        if timerIsFinished {
            playTimerSound()
            stopTimer()
        }
        
    }
  }
  
  func stopTimer(){
    timerIsPaused = true
    timer?.invalidate()
    timer = nil
  }
}
