//
//  RoutineListView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/9/23.
//

import Foundation
import SwiftUI

struct RoutineListView: View {
    // Sample routines to display - Replace with your own data source
    let routines = [
        RoutineModel(title: "Morning Routine", tasks: ["Meditation", "Exercise", "Breakfast"]),
        RoutineModel(title: "Work Session", tasks: ["Emails", "Design Meeting", "Code Review"]),
        RoutineModel(title: "Evening Routine", tasks: ["Dinner", "Reading", "Planning Next Day"])
    ]

    var body: some View {
        NavigationView {
            List(routines, id: \.title) { routine in
//                NavigationLink(destination: RoutineDetailView(routine: routine)) {
//                    Text(routine.title)
//                }
            }
            .navigationBarTitle("Routines")
        }
    }
}

struct RoutineListView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineListView()
    }
}

// Dummy model for Routine
// Replace this with your actual RoutineModel definition
struct RoutineModel {
    var title: String
    var tasks: [String]
}
