//
//  DeadlineCard.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI

struct DeadlineCard: View {
    var deadline: Deadline
    var onEdit: () -> Void
    var onDelete: () -> Void

    @State private var showActionMenu = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Prize Image
                if let prizeImageData = deadline.prizeImageData, let prizeImage = UIImage(data: prizeImageData) {
                    Image(uiImage: prizeImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(deadline.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Due: \(deadline.dueDate, formatter: DateFormatter.shortDateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Progress Bar
                    ProgressView(value: deadline.progress, total: 1)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 5)
                        .padding(.top, 5)
                }
                .padding(.leading, 10)

                Spacer()

                // Three dots menu button (for more actions)
                Button(action: {
                    showActionMenu.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .rotationEffect(Angle(degrees: 90))
                }
                .actionSheet(isPresented: $showActionMenu) {
                    ActionSheet(title: Text("Actions"), buttons: [
                        .default(Text("Edit")) {
                            onEdit()
                        },
                        .destructive(Text("Delete")) {
                            onDelete()
                        },
                        .cancel()
                    ])
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    DeadlineCard(deadline: Deadline(
        name: "Plan Weekly Meal Prep",
        dueDate: Date(),
        prizeName: "Free Meal",
        prizeImageData: nil // Optional: add image data here if needed
    )) {
        // Action for editing the deadline
        print("Edit Deadline")
    } onDelete: {
        // Action for deleting the deadline
        print("Delete Deadline")
    }
}



