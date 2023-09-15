//
//  OnboardingView.swift
//  Epoch
//
//  Created by Justin Arnold on 9/15/23.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    var body: some View {
        VStack {
            Text("Welcome to Epoch!")
                .font(.title)
            Text("In order to allow timers to notify you and continue in the background, we'd like to send you notifications.")
                .padding(16)
            Button("Grant Permission") {
                requestNotificationPermission()
            }.buttonStyle(.borderedProminent)
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied because: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
}
