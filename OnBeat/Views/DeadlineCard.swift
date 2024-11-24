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
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .bottomTrailing) {
                if let prizeImageData = deadline.prizeImageData, let prizeImage = UIImage(data: prizeImageData) {
                    Image(uiImage: prizeImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(CustomTopRoundedRectangle(cornerRadius: 15))
                        .overlay(
                            CustomTopRoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                } else {
                    CustomTopRoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 180)
                }


                // Days Left Badge - Positioned at the bottom right
                Text("\(daysLeft()) days left")
//                    .font(.headline)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding([.bottom, .trailing], 10)
                    .foregroundColor(.black)
            }

            // Text and Progress Section
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(deadline.name)
//                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("· \(deadline.teamName) \(deadline.teamEmoji)")
//                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Three dots menu button (for more actions)
                    Button(action: {
                        showActionMenu.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
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

                Text(deadline.prizeName)
//                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)

                // Progress Bar
                ProgressView(value: deadline.progress, total: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                    .frame(height: 8)
                    .cornerRadius(4)
                    .padding(.top, 5)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }

    private func daysLeft() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline.dueDate)
        return components.day ?? 0
    }
}

#Preview {
    DeadlineCard(deadline: Deadline(
        name: "Hackathon",
        dueDate: Calendar.current.date(byAdding: .day, value: 23, to: Date())!,
        teamName: "Sushi",
        teamEmoji: "😂",
        prizeName: "Sushi",
        prizeImageData: nil
    )) {
        print("Edit Deadline")
    } onDelete: {
        print("Delete Deadline")
    }
}
