import SwiftUI


struct ContentView: View {
    
    @State private var isNotificationPermissionGranted: Bool = false

    var body: some View {
        VStack {
            if isNotificationPermissionGranted == false {
                OnboardingView()
            } else {
                TimerView()
            }
        }.onAppear(perform: checkNotificationPermission)
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
