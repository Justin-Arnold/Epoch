//
//  SettingsView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/9/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("baseTimeInMinutes") private var baseTimeInMinutes: Int = 25
    let timeOptions = Array(1...60)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    Picker("Base Time", selection: $baseTimeInMinutes) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text("\(time) minutes")
                        }
                    }
                    
                }

                // Add other sections for different categories of settings
                // For example, appearance settings, account settings, etc.
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
