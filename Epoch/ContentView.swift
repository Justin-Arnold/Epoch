import SwiftUI

struct ContentView: View {
    
    // Constant Data
    let baseTime = 10
  
    // Stateful Data
    @State var timerIsPaused = true
    @State private var timeRemaining: Int
    @State var timer: Timer? = nil
    
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
    };
    
    
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
                    .font(.system(size: 64, weight: .bold, design: .serif))
            }
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
