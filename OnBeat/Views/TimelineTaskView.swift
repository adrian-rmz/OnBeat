//
//  TimelineTaskView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI
import UIKit

struct TimelineTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var selectedImage: UIImage?
    
    var task: TaskItem
    
    var showPickerBinding: Binding<Bool> {
        Binding(get: {
            sourceType != nil
        }, set: { newValue in
            if !newValue {
                sourceType = nil
            }
        })
    }

    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .fill(task.isCompleted ? Color.green : Color.gray)
                    .frame(width: 40, height: 40)
                
                if let image = task.completionImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 35, height: 35)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let completionDate = task.completionDate {
                    Text("Completed: \(completionDate, formatter: DateFormatter.shortDateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Not completed yet")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            
            Button(action: {
                if !task.isCompleted {
                    showImageOptions()
                } else {
                    toggleTaskCompletion(with: selectedImage)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
        }
        .padding(.vertical, 10)
        .sheet(isPresented: showPickerBinding) {
            ImagePicker(
                isImagePickerPresented: showPickerBinding,
                selectedImage: $selectedImage,
                sourceType: sourceType ?? .photoLibrary
            )
            .onDisappear {
                if let image = selectedImage {
                    toggleTaskCompletion(with: image)
                }
            }
        }
    }
    
    private func toggleTaskCompletion(with image: UIImage?) {
        task.isCompleted.toggle()
        task.completionDate = task.isCompleted ? Date() : nil
        task.completionImageData = image?.jpegData(compressionQuality: 0.8)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save task completion: \(error)")
        }
    }
    
    private func showImageOptions() {
        let alert = UIAlertController(title: "Add an Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
                sourceType = .camera
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
            sourceType = .photoLibrary
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}

