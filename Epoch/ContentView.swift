import SwiftUI
import AVFoundation

struct ContentView: View {
    
    // Constant Data
    let baseTime = 1500
  
    // Stateful Data
    @State var timerIsPaused = true
    @State private var timeRemaining: Int
    @State var timer: Timer? = nil
    @State private var player: AVAudioPlayer? = nil
    @State private var isNotificationPermissionGranted: Bool = false
    
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
        VStack {
            if isNotificationPermissionGranted == false {
                OnboardingView()
            } else {
                VStack {
                    TimerCircle();
                    if timerIsPaused {
                        VStack {
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
            }
        }.onAppear(perform: checkNotificationPermission)
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
            Label("restart", systemImage: "backward.end.alt")
        }.controlSize(.mini).padding(4)
    }
    
    func TimerCircle() -> some View {
        ZStack{
            Circle()
                .fill(Color.blue)
                .padding(20)
            Circle()
                .fill(Color.white)
                .padding(28)
            VStack {
                Text("\(secondsToTime(sec: timeRemaining))")
                    .foregroundColor(Color.black)
                    .font(.system(size: 64, weight: .bold, design: .serif))
            }
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
