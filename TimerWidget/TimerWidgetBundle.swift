//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Justin Arnold on 1/4/24.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
