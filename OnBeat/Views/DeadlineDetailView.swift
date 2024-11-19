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
                ZStack(alignment: .bottomLeading) {
                    // Image Header
                    if let prizeImageData = deadline.prizeImageData, let prizeImage = UIImage(data: prizeImageData) {
                        Image(uiImage: prizeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                    }

                    // Title Section
                    Text(deadline.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.leading, .bottom], 16) // Padding for bottom-left alignment
                        .foregroundColor(.white)
                }

                // Details Section
                HStack(spacing: 15) {
                    DetailCard(icon: "trophy", title: deadline.prizeName, backgroundColor: .yellow)
                    VStack {
                        Text(deadline.teamEmoji)
                            .font(.system(size: 40))
                            .bold()
                            .padding(.bottom, 4)
                        Text("days left")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 100, height: 100)
                    .background(.accent)
                    .cornerRadius(15)
                    VStack {
                        Text("\(daysLeft())")
                            .font(.system(size: 40))
                            .bold()
                            .padding(.bottom, 4)
                        Text("days left")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 100, height: 100)
                    .background(.accent)
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                
                // Progress View
                ProgressView(value: deadline.progress, total: 1)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 5)
                    .padding(.vertical)
                    .padding(.horizontal, 40)

                // Tasks Section
                VStack(spacing: 15) {
                    ForEach(deadline.tasks, id: \.id) { task in // Explicitly use the `id` property
                        TimelineTaskView(task: task)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: takeScreenshotAndShare) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3) // Tamaño del ícono
                            .foregroundColor(.black)

                        Text("Share with your team")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding() // Espaciado interno del botón
                    .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
                    .background(Color.yellow)
                    .cornerRadius(10) // Bordes redondeados
                }
                .padding(.vertical)
                .padding(.horizontal, 40)
                .sheet(isPresented: $showShareSheet) {
                    if let capturedImage = capturedImage {
                        ShareSheet(activityItems: [capturedImage])
                    }
                }
            }
        }
//        .navigationTitle(deadline.name)
        .toolbar {
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
    
    private func daysLeft() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline.dueDate)
        return components.day ?? 0
    }
    
    // Función para capturar la pantalla y mostrar la hoja de compartir
    private func takeScreenshotAndShare() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Failed to access window scene.")
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

// Custom DetailCard for the Header Section
struct DetailCard: View {
    let icon: String
    let title: String
    let backgroundColor: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .padding(.bottom, 4)
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(backgroundColor)
        .cornerRadius(15)
    }
}

// ShareSheet para presentar actividades de compartir
//struct ShareSheet: UIViewControllerRepresentable {
//    let activityItems: [Any]
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}


struct DeadlineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTasks = [
            TaskItem(name: "Read slides", isCompleted: false, index: 1),
            TaskItem(name: "Review code", isCompleted: true, completionDate: Date(), index: 2)
        ]

        let mockDeadline = Deadline(
            name: "Hackathon",
            dueDate: Calendar.current.date(byAdding: .day, value: 23, to: Date())!,
            teamName: "OnBeat",
            teamEmoji: "🎯",
            prizeName: "Sushi 🍣",
            prizeImageData: nil
        )

        return NavigationView {
            DeadlineDetailView(deadline: mockDeadline)
        }
    }
}
