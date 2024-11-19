//
//  EditDeadlineView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI

struct EditDeadlineView: View {
    @Environment(\.modelContext) var modelContext
    
    var deadline: Deadline
    @Binding var isPresented: Bool
    
    @State private var newName: String
    @State private var newDueDate: Date
    @State private var newTeamName: String
    @State private var newTeamEmoji: String
    @State private var newPrizeName: String
    @State private var newPrizeImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showEmojiInputAlert = false // For emoji selection

    init(deadline: Deadline, isPresented: Binding<Bool>) {
        self.deadline = deadline
        self._isPresented = isPresented
        
        _newName = State(initialValue: deadline.name)
        _newDueDate = State(initialValue: deadline.dueDate)
        _newTeamName = State(initialValue: deadline.teamName)
        _newTeamEmoji = State(initialValue: deadline.teamEmoji)
        _newPrizeName = State(initialValue: deadline.prizeName)
        _newPrizeImage = State(initialValue: deadline.prizeImageData != nil ? UIImage(data: deadline.prizeImageData!) : nil)
    }

    var body: some View {
        NavigationView {
            Form {
                // Team Section
                Section("Edit your Team") {
                    VStack(spacing: 20) {
                        // Circular Emoji Container
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 120)

                            if !newTeamEmoji.isEmpty {
                                Text(newTeamEmoji)
                                    .font(.system(size: 60)) // Emoji size
                            }
                        }
                        .onTapGesture {
                            showEmojiInputAlert = true // Show emoji input alert
                        }

                        // Button to Add/Change Emoji
                        Button(action: {
                            showEmojiInputAlert = true
                        }) {
                            Text("Change emoji")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    // Team Name Field
                    TextField("Team Name", text: $newTeamName)
                }
                
                // Deadline Section
                Section("Deadline Information") {
                    // Image Section
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        if let newPrizeImage = newPrizeImage {
                            // Show selected image
                            Image(uiImage: newPrizeImage)
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
                            // Placeholder when no image is selected
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                                Text("Add Image")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Text Fields
                    TextField("Deadline Name", text: $newName)
                    DatePicker("Due Date", selection: $newDueDate, displayedComponents: .date)
                    TextField("Prize Name", text: $newPrizeName)
                }
            }
            .navigationTitle("Edit Deadline")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Convert selected image to Data if it exists
                        let newPrizeImageData = newPrizeImage?.jpegData(compressionQuality: 0.8)
                        
                        // Save the changes to the deadline
                        editDeadline(
                            from: modelContext,
                            deadline: deadline,
                            newName: newName,
                            newDueDate: newDueDate,
                            newTeamName: newTeamName,
                            newTeamEmoji: newTeamEmoji,
                            newPrizeName: newPrizeName,
                            newPrizeImageData: newPrizeImageData
                        )
                        isPresented = false
                    }
                    .disabled(newName.isEmpty || newPrizeName.isEmpty || newTeamName.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $newPrizeImage,
                    sourceType: .photoLibrary
                )
            }
            .alert("Change Emoji", isPresented: $showEmojiInputAlert) {
                TextField("Enter an emoji", text: $newTeamEmoji)
                    .onChange(of: newTeamEmoji) { newValue in
                        limitToSingleEmoji(newValue: newValue)
                    }
                Button("Save") {}
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a single emoji to represent your team.")
            }
        }
    }

    // Helper to limit input to a single emoji
    private func limitToSingleEmoji(newValue: String) {
        if newValue.count > 1 {
            newTeamEmoji = String(newValue.prefix(1)) // Keep only the first character
        }
    }
}

