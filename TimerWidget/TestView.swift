//
//  TestView.swift
//  Epoch
//
//  Created by Justin Arnold on 1/6/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct TestView: View {
    
    var context: ActivityViewContext<TimerWidgetAttributes>
    
    var body: some View {
            
            let color = Color.green
            
            ProgressView(value: abs(10), total: 100) {
                Image(systemName: "arrowshape.down.fill")
            }
            .progressViewStyle(.circular)
            .tint(color)
            .foregroundColor(color)
        }
}

//#Preview {
//    
//    TestView()
//}
