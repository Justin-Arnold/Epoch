//
//  ChooseFocusView.swift
//  Epoch
//
//  Created by Justin Arnold on 9/18/23.
//

import SwiftUI

struct ChooseFocusView: View {
    
    @State var priorities: [Priority] = [
        Priority(name: "Epoch", id: UUID()),
        Priority(name: "2nd Brain", id: UUID()),
        Priority(name: "Finances", id: UUID()),
        Priority(name: "Misc", id: UUID())
    ]
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // This spacer moves the initial position of the first card to the middle
                        Spacer().frame(width: geometry.size.width / 2 - 135)  // assuming 135 is half of the card's width
                        
                        ForEach(priorities) { priority in
                            NavigationLink(destination: TimerView(priority: priority)) {
                                PriorityCard(title: priority.name)
                            }
                        }
                        
                        // This spacer ensures the last card can also be centered
                        Spacer().frame(width: geometry.size.width / 2 - 135)
                    }
                }
                .frame(height: 400, alignment: .center)
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
