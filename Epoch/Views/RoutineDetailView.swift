//
//  RoutineDetailView.swift
//  Epoch
//
//  Created by Justin Arnold on 12/11/23.
//

import Foundation
import SwiftUI

struct RoutineDetailView: View {
    var routine: RoutineModel

    var body: some View {
        List {
            Section(header: Text("Tasks")) {
                ForEach(routine.tasks, id: \.self) { task in
                    Text(task)
                }
            }
        }
        .navigationTitle(routine.title)
        .navigationBarTitleDisplayMode(.inline)
        // Add additional functionality like edit and delete buttons if needed
    }
}

struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineDetailView(routine: RoutineModel(title: "Sample Routine", tasks: ["Task 1", "Task 2"]))
    }
}
