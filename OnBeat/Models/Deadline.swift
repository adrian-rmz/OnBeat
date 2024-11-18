//
//  Deadline.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftData
import Foundation
import UIKit

@Model
final class Deadline {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var dueDate: Date
    var friendsGroup: String
    var prizeName: String
    var prizeImageData: Data?
    var tasks: [TaskItem] = []

    init(name: String, dueDate: Date, friendsGroup: String, prizeName: String, prizeImageData: Data? = nil) {
        self.name = name
        self.dueDate = dueDate
        self.friendsGroup = friendsGroup
        self.prizeName = prizeName
        self.prizeImageData = prizeImageData
    }

    var prizeImage: UIImage? {
        guard let data = prizeImageData else { return nil }
        return UIImage(data: data)
    }

    var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        let completedCount = tasks.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(tasks.count)
    }
}

