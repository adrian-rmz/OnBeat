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
    @State private var prizeName = ""
    @State private var prizeImageData: Data? = nil // Store image data here
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var isCamera = false // Track whether we are using the camera or the library
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deadline Information")) {
                    TextField("Deadline Name", text: $deadlineName)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                Section(header: Text("Prize Information")) {
                    TextField("Prize Name", text: $prizeName)
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .padding(.vertical)
                    }
                    
                    Button("Select or Take a Photo") {
                        isImagePickerPresented = true
                        isCamera = true // Use the camera by default
                    }
                }
            }
            .navigationTitle("Add Deadline")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false // Dismiss the view when cancel is tapped
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Convert UIImage to Data
                        if let selectedImage = selectedImage {
                            prizeImageData = selectedImage.jpegData(compressionQuality: 0.8) // Convert to Data (JPEG format)
                        }
                        
                        addDeadline(to: modelContext, name: deadlineName, dueDate: dueDate, prizeName: prizeName, prizeImageData: prizeImageData)
                        isPresented = false // Dismiss the view after saving
                    }
                    .disabled(deadlineName.isEmpty || prizeName.isEmpty) // Disable if fields are empty
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                // Image Picker to choose photo from library or camera
                ImagePicker(isImagePickerPresented: $isImagePickerPresented, selectedImage: $selectedImage, sourceType: .photoLibrary)
            }
        }
    }
}

