//
//  TimerWidgetAttributes.swift
//  Epoch
//
//  Created by Justin Arnold on 1/4/24.
//

import Foundation
import ActivityKit

struct TimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
