//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Justin Arnold on 1/4/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: TimerWidgetAttributes.self) {
            context in LockScreenView(context: context)
        } 
    
        dynamicIsland: { context in
            DynamicIsland {
                
                let color = Color.green
                
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.time)
                        .font(.title3)
                        .bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.time)
                        .foregroundColor(color)
                        .font(.title3)
                        .bold()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.attributes.sessionName)
                            .foregroundColor(color)
                        Spacer()
                        //PercentView(context: context)
                    }
                    .font(.title3)
                    .bold()
                }
            } compactLeading: {
                Text(context.state.time)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.green)
            } compactTrailing: {
                Text(context.state.time)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.green)
            } minimal: {
                Image(systemName: "circle")
                    .foregroundColor(.green)
            }
        }
    }
}
        

extension TimerWidgetAttributes {
    fileprivate static var preview: TimerWidgetAttributes {
        TimerWidgetAttributes(
            sessionName: "Break",
            sessionCount: 2
        )
    }
}
//
extension TimerWidgetAttributes.ContentState {
    fileprivate static var smiley: TimerWidgetAttributes.ContentState {
        TimerWidgetAttributes.ContentState(time: "5:00")
     }
     
     fileprivate static var starEyes: TimerWidgetAttributes.ContentState {
         TimerWidgetAttributes.ContentState(time: "25:00")
     }
}
//
#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
   TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState.smiley
    TimerWidgetAttributes.ContentState.starEyes
}
