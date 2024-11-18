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
    @Binding var isPresented: Bool  // To dismiss the sheet
    @State private var newName: String
    @State private var newDueDate: Date
    @State private var newPrizeName: String
    @State private var newPrizeImage: UIImage? // Change Data? to UIImage?
    @State private var showImagePicker = false

    init(deadline: Deadline, isPresented: Binding<Bool>) {
        self.deadline = deadline
        self._isPresented = isPresented
        
        _newName = State(initialValue: deadline.name)
        _newDueDate = State(initialValue: deadline.dueDate)
        _newPrizeName = State(initialValue: deadline.prizeName)
        _newPrizeImage = State(initialValue: deadline.prizeImageData != nil ? UIImage(data: deadline.prizeImageData!) : nil) // Initialize the image from the data if available
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deadline Information")) {
                    TextField("Name", text: $newName)
                    
                    DatePicker("Due Date", selection: $newDueDate, displayedComponents: .date)
                }
                Section(header: Text("Prize Information")) {
                    TextField("Prize Name", text: $newPrizeName)
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Choose Prize Image")
                            .foregroundColor(.blue)
                    }
                    
                    if let prizeImage = newPrizeImage {
                        Image(uiImage: prizeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Edit Deadline")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false // Dismiss the view if the user cancels
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Convert the selected image back to Data if a new image was selected
                        let newPrizeImageData = newPrizeImage?.jpegData(compressionQuality: 0.8) // Convert UIImage to Data
                        // Save the changes to the deadline
                        editDeadline(from: modelContext, deadline: deadline, newName: newName, newDueDate: newDueDate, newPrizeName: newPrizeName, newPrizeImageData: newPrizeImageData)
                        isPresented = false  // Dismiss the sheet after saving
                    }
                    .disabled(newName.isEmpty || newPrizeName.isEmpty) // Disable button if fields are empty
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(isImagePickerPresented: $showImagePicker, selectedImage: $newPrizeImage, sourceType: .photoLibrary) // Pass UIImage binding
            }
        }
    }
}
