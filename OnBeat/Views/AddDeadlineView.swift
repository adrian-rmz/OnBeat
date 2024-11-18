//
//  AddDeadlineView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI
import SwiftData

struct AddDeadlineView: View {
    @Binding var isPresented: Bool
    
    @Environment(\.modelContext) var modelContext
    
    @State private var deadlineName = ""
    @State private var dueDate = Date()
    @State private var friendsGroup = ""
    @State private var prizeName = ""
    @State private var prizeImageData: Data? = nil
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
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
                TextField("Friends Group", text: $friendsGroup)
                TextField("Prize Name", text: $prizeName)
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
                            friendsGroup: friendsGroup,
                            prizeName: prizeName,
                            prizeImageData: prizeImageData
                        )
                        isPresented = false
                    }
                    .disabled(deadlineName.isEmpty || prizeName.isEmpty || friendsGroup.isEmpty)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $selectedImage,
                    sourceType: .photoLibrary
                )
            }
        }
    }
}

