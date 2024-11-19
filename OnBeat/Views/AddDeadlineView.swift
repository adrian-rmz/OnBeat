//
//  AddDeadlineView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI

struct AddDeadlineView: View {
    @Binding var isPresented: Bool

    @Environment(\.modelContext) var modelContext

    @State private var deadlineName = ""
    @State private var dueDate = Date()
    @State private var teamName = ""
    @State private var prizeName = ""
    @State private var prizeImageData: Data? = nil
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var teamEmoji = "" // Stores the selected emoji
    @State private var showEmojiInputAlert = false // Controls showing emoji alert
    @State private var newEmoji = "" // Temporary state for entering emoji

    var body: some View {
        NavigationView {
            Form {
                Section("Create your Team") {
                    VStack(spacing: 20) {
                        // Centered Emoji Container
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 120, height: 120)

                                if !teamEmoji.isEmpty {
                                    Text(teamEmoji)
                                        .font(.system(size: 60)) // Emoji size
                                }
                            }

                            // Button to Add Emoji
                            Button(action: {
                                showEmojiInputAlert = true // Show alert
                            }) {
                                Text("Add an emoji")
                                    .font(.headline)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center align
                    }

                    // Team Name Field
                    TextField("Team Name", text: $teamName)
                }

                Section("Deadline Information") {
                    // Image Section
                    Button(action: {
                        isImagePickerPresented = true // Open image picker
                    }) {
                        if let selectedImage = selectedImage {
                            // Show selected image
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal)
                        } else {
                            // Placeholder button when no image is selected
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                                Text("Add Prize Image")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal)
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove button animation

                    // Text Fields
                    TextField("Deadline Name", text: $deadlineName)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    TextField("Prize Name", text: $prizeName)
                }
            }
            .navigationTitle("Add Deadline")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let selectedImage = selectedImage {
                            prizeImageData = selectedImage.jpegData(compressionQuality: 0.8)
                        }

                        addDeadline(
                            to: modelContext,
                            name: deadlineName,
                            dueDate: dueDate,
                            teamName: teamName,
                            teamEmoji: teamEmoji,
                            prizeName: prizeName,
                            prizeImageData: prizeImageData
                        )
                        isPresented = false
                    }
                    .disabled(deadlineName.isEmpty || prizeName.isEmpty || teamName.isEmpty || teamEmoji.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $selectedImage,
                    sourceType: .photoLibrary
                )
            }
            // Emoji Input Alert
            .alert("Add an Emoji", isPresented: $showEmojiInputAlert) {
                TextField("Enter an emoji", text: $newEmoji)
                    .onChange(of: newEmoji) { newValue in
                        limitToSingleEmoji(newValue: newValue)
                    }
                Button("Add") {
                    teamEmoji = newEmoji
                    newEmoji = ""
                }
                Button("Cancel", role: .cancel) {
                    newEmoji = ""
                }
            } message: {
                Text("Enter a single emoji to represent your team.")
            }
        }
    }

    // Helper to limit the input to a single emoji
    private func limitToSingleEmoji(newValue: String) {
        if newValue.count > 1 {
            newEmoji = String(newValue.prefix(1)) // Keep only the first character
        }
    }
}
