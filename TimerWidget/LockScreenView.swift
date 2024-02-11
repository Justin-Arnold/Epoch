//
//  LockScreenView.swift
//  Epoch
//
//  Created by Justin Arnold on 1/4/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct LockScreenView: View {
    
    var context: ActivityViewContext<TimerWidgetAttributes>
    
    var body: some View {
        
//        let color =  Color.wh
        
        HStack {
            
            Text(context.state.time)
                .font(.system(size: 70))
                .bold()
//                .foregroundColor(color)

            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(context.attributes.sessionName)
                    .font(.title3)
                
                HStack() {
                    Image(systemName: "circle")
                        .foregroundColor(.green)
                    Image(systemName: "circle")
                        .foregroundColor(.green)
                    Image(systemName: "circle")
                        .foregroundColor(.green)
                }.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
        .activityBackgroundTint(Color.black)
        .activitySystemActionForegroundColor(Color.white)
    }
}

