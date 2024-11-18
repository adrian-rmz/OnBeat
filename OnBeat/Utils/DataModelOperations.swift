//
//  DataModelOperations.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftUI
import SwiftData

func addDeadline(to modelContext: ModelContext, name: String, dueDate: Date, friendsGroup: String, prizeName: String, prizeImageData: Data?) {
    let newDeadline = Deadline(name: name, dueDate: dueDate, friendsGroup: friendsGroup, prizeName: prizeName, prizeImageData: prizeImageData)
    modelContext.insert(newDeadline)
}

func editDeadline(from modelContext: ModelContext, deadline: Deadline, newName: String, newDueDate: Date, newFriendsGroup: String, newPrizeName: String, newPrizeImageData: Data?) {
    deadline.name = newName
    deadline.dueDate = newDueDate
    deadline.friendsGroup = newFriendsGroup
    deadline.prizeName = newPrizeName
    deadline.prizeImageData = newPrizeImageData
    try! modelContext.save()
}

func toggleTaskCompletion(in modelContext: ModelContext, for task: TaskItem) {
    task.isCompleted.toggle()
    task.completionDate = task.isCompleted ? Date() : nil
    try? modelContext.save()
}

func addTask(from modelContext: ModelContext, to deadline: Deadline, name: String, completionDate: Date?) {
    let newTask = TaskItem(name: name, isCompleted: false, completionDate: completionDate)
    deadline.tasks.append(newTask)
}
