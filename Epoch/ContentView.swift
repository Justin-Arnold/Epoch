import SwiftUI

struct ContentView: View {
  
    @State var hours = 0;
    @State var minutes = 25;
    @State var seconds = 0;
    @State var timerIsPaused = true;
    @State var timeRemaining = 1500;
  
    @State var timer: Timer? = nil;
    
    func restartTimer() {
      timeRemaining = 1500
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
                    StartButton()
                    RestartButton()
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
                .stroke(Color.blue)
                .padding(20)
            VStack {
                Text("\(secondsToTime(sec: timeRemaining))")
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
        if timeRemaining == 0 {
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
