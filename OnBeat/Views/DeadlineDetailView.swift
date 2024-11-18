//
//  DeadlineDetailView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI

struct DeadlineDetailView: View {
    @Environment(\.modelContext) var modelContext

    var deadline: Deadline
    @State private var showAddTaskAlert = false
    @State private var newTaskName = ""
    @State private var showShareSheet = false
    @State private var capturedImage: UIImage?
    @State private var showFeedbackMessage = false // To show a message when clicking a disabled button

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Deadline Information Section
                VStack(spacing: 10) {
                    if let prizeImageData = deadline.prizeImageData, let prizeImage = UIImage(data: prizeImageData) {
                        Image(uiImage: prizeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                    }
                    Text("\(deadline.prizeName)")
                        .font(.title)
                    Text("Due: \(deadline.dueDate, formatter: DateFormatter.shortDateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ProgressView(value: deadline.progress, total: 1)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 5)
                }
                .padding(.horizontal)

                // Tasks Section
                VStack(spacing: 15) {
                    ForEach(deadline.tasks) { task in
                        TimelineTaskView(task: task)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(deadline.name)
        .toolbar {
            // Button for taking a screenshot
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    Button(action: takeScreenshot) {
                        Image(systemName: "camera")
                    }
                    .disabled(deadline.progress < 1) // Disable if progress is not 100%

                    // Overlay to detect taps on the disabled button
                    if deadline.progress < 1 {
                        Color.clear
                            .contentShape(Rectangle()) // Ensures the overlay is tappable
                            .onTapGesture {
                                showFeedbackMessage = true
                            }
                    }
                }
            }

            // Button for adding a task
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddTaskAlert = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Add Task", isPresented: $showAddTaskAlert, actions: {
            TextField("Task Name", text: $newTaskName)
            Button("Save") {
                if !newTaskName.isEmpty {
                    addTask(from: modelContext, to: deadline, name: newTaskName, completionDate: nil)
                    newTaskName = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newTaskName = ""
            }
        }, message: {
            Text("Enter the task name for this deadline.")
        })
        .sheet(isPresented: $showShareSheet, content: {
            if let image = capturedImage {
                ShareSheet(activityItems: [image])
            }
        })
        .alert(isPresented: $showFeedbackMessage) {
            Alert(
                title: Text("Action Disabled"),
                message: Text("You need to complete all tasks to share your achievement."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // Captures the current screen as an image
    private func takeScreenshot() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Failed to capture window scene.")
            return
        }

        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)

        let image = renderer.image { context in
            window.layer.render(in: context.cgContext)
        }

        capturedImage = image
        showShareSheet = true
    }
}


