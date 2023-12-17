//
//  TimerView.swift
//  Epoch
//
//  Created by Justin Arnold on 9/15/23.
//

import SwiftUI
import AVFoundation

struct TimerView: View {
    @AppStorage("baseTimeInMinutes") var baseTimeInMinutes: Int = 25
    @StateObject var viewModel = TimerViewModel()
    var priorityName: String
        
    var baseTimeInSeconds: Int {
        return baseTimeInMinutes * 60
    }
    
    init(priority: Priority) {
        self.priorityName = priority.name
    }
    
    var body: some View {
            VStack {
                Spacer()
                
                Text(timeString(from: viewModel.timeRemaining))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    if viewModel.isActive {
                        viewModel.pauseTimer()
                    } else {
                        viewModel.startTimer()
                    }
                }) {
                    Text(viewModel.isActive ? "Pause" : "Start")
                        // ... button styling ...
                }
                .padding()
                if !viewModel.isActive && viewModel.timeRemaining < baseTimeInSeconds {
                    Button(action: {
                        viewModel.resetTimer()
                    }) {
                        Text("Restart Timer")
                    }
                }

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
                        .rotationEffect(Angle(degrees: -Double(1500 - viewModel.timeRemaining))) // Rotate based on timeRemaining
                }
                .frame(width: 600, height: 150, alignment: .bottom) // Set the height to half of the circle's height
                .offset(y: 300) // Push down to only show the top third
//                .clipped() // Clip the view so the bottom half doesn't show
                .padding(.bottom, -300) // Negate the offset to maintain the layout
                
                
            }
            .background(Color.green.edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.setBaseTime(baseTimeInSeconds)
            }
            .onChange(of: baseTimeInMinutes) { newValue in
                viewModel.setBaseTime(baseTimeInSeconds)
            }
        }

    // Converts the remaining time into a String formatted as "mm:ss"
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func formatToDoubleDigit(_ number: Int) -> String {
        if number < 10 { return "0\(number)" }
        return "\(number)"
    };
    
    func secondsToTime(sec: Int) -> String {
        let minutesFromSec = sec / 60
        let remainingSec = sec % 60
        
        return "\(minutesFromSec):\(formatToDoubleDigit(remainingSec))"
    };
    
    func TimerCircle() -> some View {
        VStack {
            Spacer()
            Text(priorityName)
                .foregroundColor(Color.white).brightness(-0.4)
                .font(.system(size: 40))
            Text("\(secondsToTime(sec: viewModel.timeRemaining))")
                .foregroundColor(Color.white)
                .font(.system(size: 80, weight: .bold, design: .serif))
            Spacer()
        }
    }
    
//    private func checkNotificationPermission() {
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                DispatchQueue.main.async {
//                    switch settings.authorizationStatus {
//                    case .authorized, .provisional:
//                        isNotificationPermissionGranted = true
//                    default:
//                        isNotificationPermissionGranted = false
//                    }
//                }
//            }
//        }
    
//    func playTimerSound() {
//        guard let url = Bundle.main.url(forResource: "jingle", withExtension: "mp3") else {
//            print("Sound file not found")
//            return
//        }
//        do {
//            self.player = try AVAudioPlayer(contentsOf: url)
//            self.player?.prepareToPlay()
//            self.player?.play()
//        } catch {
//            print("Error playing sound: \(error.localizedDescription)")
//        }
//    }
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
