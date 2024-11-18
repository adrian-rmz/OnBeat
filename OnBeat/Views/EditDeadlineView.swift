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
    @State private var newFriendsGroup: String
    @State private var newPrizeName: String
    @State private var newPrizeImage: UIImage?
    @State private var isImagePickerPresented = false
    
    init(deadline: Deadline, isPresented: Binding<Bool>) {
        self.deadline = deadline
        self._isPresented = isPresented
        
        _newName = State(initialValue: deadline.name)
        _newDueDate = State(initialValue: deadline.dueDate)
        _newFriendsGroup = State(initialValue: deadline.friendsGroup)
        _newPrizeName = State(initialValue: deadline.prizeName)
        _newPrizeImage = State(initialValue: deadline.prizeImageData != nil ? UIImage(data: deadline.prizeImageData!) : nil)
    }

    var body: some View {
        NavigationView {
            Form {
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
                TextField("Friends Group", text: $newFriendsGroup)
                TextField("Prize Name", text: $newPrizeName)
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
                            newFriendsGroup: newFriendsGroup,
                            newPrizeName: newPrizeName,
                            newPrizeImageData: newPrizeImageData
                        )
                        isPresented = false
                    }
                    .disabled(newName.isEmpty || newPrizeName.isEmpty || newFriendsGroup.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $newPrizeImage,
                    sourceType: .photoLibrary
                )
            }
        }
    }
}
