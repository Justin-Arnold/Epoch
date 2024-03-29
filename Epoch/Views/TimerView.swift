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
        
    var baseTimeInSeconds: Int {
        return baseTimeInMinutes * 60
    }
    
    
    var body: some View {
            VStack {
                Spacer()
                // Timer Clock
                Text(timeString(from: viewModel.timeRemaining))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Accent"))
                    .padding()
                // Play-Pause Button
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
                // Reset Button
                if !viewModel.isActive && viewModel.timeRemaining < baseTimeInSeconds {
                    Button(action: {
                        viewModel.resetTimer()
                    }) {
                        Text("Restart Timer")
                    }
                }
                Spacer()
                // Ticking Circle Element
                ZStack {
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 20))
                        .opacity(0.3)
                        .foregroundColor(Color("Accent"))
                        .frame(width: 600, height: 600)
                    
                    Circle()
                        .stroke(Color("Base"), style: StrokeStyle(lineWidth: 20, lineCap: .butt, dash: [2, 28]))
                        .frame(width: 600, height: 600)
                        .rotationEffect(Angle(degrees: -Double(1500 - viewModel.timeRemaining))) // Rotate based on timeRemaining
                }
                .frame(width: 600, height: 150, alignment: .bottom) // Set the height to half of the circle's height
                .offset(y: 300) // Push down to only show the top third
                .padding(.bottom, -300) // Negate the offset to maintain the layout
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("BackgroundAccent")]), startPoint: .top, endPoint: .bottom))
                        .edgesIgnoringSafeArea(.all) // To extend the gradient to the screen edges
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
