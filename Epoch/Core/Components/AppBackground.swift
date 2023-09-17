//
//  WavyBackground.swift
//  Epoch
//
//  Created by Justin Arnold on 9/15/23.
//
import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.mint]), startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(gradient: Gradient(colors: [Color.clear, Color.accentColor.opacity(0.5)]), center: .center, startRadius: 10, endRadius: 400)
        }
        .blur(radius: 40)
        .edgesIgnoringSafeArea(.all)
    }
}
