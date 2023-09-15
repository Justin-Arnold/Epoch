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
      ZStack{
          Circle()
              .stroke(Color.blue)
              .padding(20)
          VStack {
              Text("\(secondsToTime(sec: timeRemaining))")
              if timerIsPaused {
                  HStack {
                      Button(action:{
                          self.restartTimer()
                      }){
                          Image(systemName: "backward.end.alt")
                              .padding(.all)
                      }
                      .padding(.all)
                      Button(action:{
                          self.startTimer()
                      }){
                          Image(systemName: "play.fill")
                              .padding(.all)
                      }
                      .padding(.all)
                  }
              } else {
                  Button(action:{
                      self.stopTimer()
                  }){
                      Image(systemName: "stop.fill")
                          .padding(.all)
                  }
                  .padding(.all)
              }
          }
      }
    };
  
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
