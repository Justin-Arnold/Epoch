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
    @State private var routines = [
        RoutineModel(title: "Morning Routine", tasks: ["Meditation", "Exercise", "Breakfast"]),
        RoutineModel(title: "Work Session", tasks: ["Emails", "Design Meeting", "Code Review"]),
        RoutineModel(title: "Evening Routine", tasks: ["Dinner", "Reading", "Planning Next Day"])
    ]

    @State private var showingAddRoutineView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(routines, id: \.title) { routine in
                    NavigationLink(destination: RoutineDetailView(routine: routine)) {
                        Text(routine.title)
                    }
                }
            }
            .navigationBarTitle("Routines")
            .navigationBarItems(trailing: Button(action: {
                showingAddRoutineView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddRoutineView) {
                AddRoutineView(routines: $routines)
            }
        }
    }
}

struct AddRoutineView: View {
    @Binding var routines: [RoutineModel]
    @State private var title = ""
    @State private var tasks = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Tasks (comma separated)")) {
                    TextField("Task 1, Task 2, ...", text: $tasks)
                }
            }
            .navigationBarTitle("Add Routine", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                addRoutine()
                dismiss()
            })
        }
    }

    func addRoutine() {
        let newTasks = tasks.components(separatedBy: ", ")
        let newRoutine = RoutineModel(title: title, tasks: newTasks)
        routines.append(newRoutine)
    }

    func dismiss() {
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}

struct RoutineListView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineListView()
    }
}

// Assuming RoutineModel looks something like this
struct RoutineModel {
    var title: String
    var tasks: [String]
}
