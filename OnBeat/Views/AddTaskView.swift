//
//  AddTaskView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) var modelContext
    
    var deadline: Deadline
    @Binding var isPresented: Bool
    
    @State private var taskName = ""
    @State private var showAlert = false

    var body: some View {
        VStack {
            Button("Add Task") {
                showAlert = true
            }
            .alert("Add Task", isPresented: $showAlert, actions: {
                TextField("Task Name", text: $taskName)
                
                Button("Save") {
                    if !taskName.isEmpty {
                        addTask(from: modelContext, to: deadline, name: taskName, completionDate: nil)
                        isPresented = false
                    }
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("Enter the task name below.")
            })
        }
    }
}

