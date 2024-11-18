//
//  DeadlinesView.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI
import SwiftData

struct DeadlinesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var deadlines: [Deadline]
    
    @State private var isPresentingAddDeadlineView = false
    @State private var selectedDeadline: Deadline?
    
    var editDeadlineBinding: Binding<Bool> {
        Binding(get: {
            selectedDeadline != nil
        }, set: { newValue in
            if !newValue {
                selectedDeadline = nil
            }
        })
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(deadlines) { deadline in
                        NavigationLink(destination: DeadlineDetailView(deadline: deadline)) {
                            DeadlineCard(
                                deadline: deadline,
                                onEdit: {
                                    selectedDeadline = deadline
                                },
                                onDelete: {
                                    modelContext.delete(deadline)
                                }
                            )
                            .padding(.horizontal)
                        }
                    }

                }
                .padding(.top)
            }
            .navigationTitle("Deadlines")
            .toolbar {
                Button(action: {
                    isPresentingAddDeadlineView = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $isPresentingAddDeadlineView) {
                AddDeadlineView(isPresented: $isPresentingAddDeadlineView)
            }
            .sheet(isPresented: editDeadlineBinding) {
                if let selectedDeadline = selectedDeadline {
                    EditDeadlineView(
                        deadline: selectedDeadline,
                        isPresented: editDeadlineBinding
                    )
                }
            }
        }
    }
}

#Preview {
    DeadlinesView()
}








