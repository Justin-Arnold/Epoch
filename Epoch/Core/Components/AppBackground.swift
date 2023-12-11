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
            LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.accentColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .blur(radius: 20)
    }
}
