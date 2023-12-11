//
//  PriorityCard.swift
//  Epoch
//
//  Created by Justin Arnold on 9/17/23.
//

import SwiftUI

struct PriorityCard: View {
    
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.indigo).brightness(0.6).frame(
                width: 200, height: 300
            )
            VStack {
                Text(title).font(.title2).foregroundColor(.indigo).brightness(-0.8).bold(true)
                StartButton()
            }
            
        }.padding(20)
    }
    
    func StartButton() -> some View {
        return Button(action: {}) {
            Label("", systemImage: "play.fill").foregroundColor(.indigo).brightness(-0.8)
        }.controlSize(.large)
    }
}
