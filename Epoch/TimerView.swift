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
    @State private var isActive: Bool = false
    @State var timerIsPaused = true
    @State private var timeRemaining: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var player: AVAudioPlayer? = nil
    @State private var isNotificationPermissionGranted: Bool = false
    @State private var dragOffset: CGFloat = 0.0
    @State private var priorityName: String
    
    // Computed Data
    var timerIsFinished: Bool {
        return timeRemaining == 0
    }
    
    init(priority: Priority) {
        timeRemaining = self.baseTime
        priorityName = priority.name
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
            VStack {
                Spacer()
                
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    self.isActive.toggle()
                }) {
                    Text(isActive ? "Pause" : "Start")
                        .foregroundColor(.black)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(Circle())
                        
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 20))
                        .opacity(0.3)
                        .foregroundColor(Color.white)
                        .frame(width: 600, height: 600)
                    
                    Circle()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 20, lineCap: .butt, dash: [2, 28]))
                        .frame(width: 600, height: 600)
                        .rotationEffect(Angle(degrees: -Double(1500 - timeRemaining))) // Rotate based on timeRemaining
                }
                .frame(width: 600, height: 150, alignment: .bottom) // Set the height to half of the circle's height
                .offset(y: 300) // Push down to only show the top third
//                .clipped() // Clip the view so the bottom half doesn't show
                .padding(.bottom, -300) // Negate the offset to maintain the layout
                
                
            }
            .background(Color.green.edgesIgnoringSafeArea(.all))
            .onReceive(timer) { _ in
                if self.isActive && self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
        }
    //    var body: some View {
//        VStack() {
//            TimerCircle()
//            Spacer();
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .aspectRatio(3.0, contentMode: .fit)
//                    .padding(8)
//                    .shadow(radius: 4.0)
//                if timerIsPaused {
//                    HStack {
//                        if timerIsFinished {
//                            RestartButton()
//                        } else {
//                            StartButton()
//                            RestartButton()
//                        }
//                    }
//                } else {
//                    StopButton()
//                }
//            }
//        }.gesture(DragGesture()
//            .onChanged({ gestureValue in
//                self.dragOffset = gestureValue.translation.height
//                self.timeRemaining -= Int(self.dragOffset / 10)
//                self.timeRemaining = max(self.timeRemaining, 0)
//            })
//            .onEnded({ _ in
//                self.dragOffset = 0.0
//            })
//        )
//    }

    // Converts the remaining time into a String formatted as "mm:ss"
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
//    func StartButton() -> some View {
//        return Button(action: {self.startTimer()}) {
//            Label("play", systemImage: "play.fill")
//        }.buttonStyle(.borderedProminent).controlSize(.large)
//    }
//    
//    func StopButton() -> some View {
//        return Button(action: {self.stopTimer()}) {
//            Label("stop", systemImage: "stop.fill")
//        }.buttonStyle(.borderedProminent).controlSize(.large)
//    }
    
    func RestartButton() -> some View {
        return Button(action: {self.restartTimer()}) {
            Label("", systemImage: "backward.end.alt")
        }.controlSize(.mini).padding(4)
    }
    
    func TimerCircle() -> some View {
        VStack {
            Spacer()
            Text(priorityName)
                .foregroundColor(Color.white).brightness(-0.4)
                .font(.system(size: 40))
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
  
//  func startTimer(){
//    timerIsPaused = false
//      if timeRemaining == 0 {
//         restartTimer()
//      }
//    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
//        timeRemaining -= 1
//        if timerIsFinished {
//            playTimerSound()
//            stopTimer()
//        }
//        
//    }
//  }
//  
//  func stopTimer(){
//    timerIsPaused = true
//    timer?.invalidate()
//    timer = nil
//  }
}

struct DashedTimerArc: Shape {
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * Double(progress)),
                    clockwise: false)
        return path
    }
}
