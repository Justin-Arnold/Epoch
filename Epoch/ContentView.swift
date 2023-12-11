import SwiftUI

struct ContentView: View {
    
    @State private var isNotificationPermissionGranted: Bool = false

    var body: some View {
        ZStack {
            if isNotificationPermissionGranted == false {
                OnboardingView()
            } else {
                MainTabView()  // Replacing ChooseFocusView with MainTabView
            }
        }.onAppear(perform: checkNotificationPermission)
    }

    private func checkNotificationPermission() {
        UNUserNotificationCenter
        .current()
        .getNotificationSettings { settings in
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

//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//    let standard = UINavigationBarAppearance()
//    standard.backgroundColor = .red //When you scroll or you have title (small one)
//
//    let compact = UINavigationBarAppearance()
//    compact.backgroundColor = .green //compact-height
//
//    let scrollEdge = UINavigationBarAppearance()
//    scrollEdge.backgroundColor = .blue //When you have large title
//
//    navigationBar.standardAppearance = standard
//    navigationBar.compactAppearance = compact
//    navigationBar.scrollEdgeAppearance = scrollEdge
// }
//}
