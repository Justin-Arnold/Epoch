//
//  MainTabView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/9/23.
//

import SwiftUI
import Foundation

struct MainTabView: View {
    let examplePriority = Priority(name: "Work", id: UUID())
    
    var body: some View {
        TabView {
            TimerView(priority: examplePriority)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            RoutineListView()
                .tabItem {
                    Label("Routines", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
