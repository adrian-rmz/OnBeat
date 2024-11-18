//
//  TaskItem.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 18/11/24.
//

import SwiftData
import UIKit

@Model
final class TaskItem {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var isCompleted: Bool = false
    var completionDate: Date?
    var completionImageData: Data?

    init(name: String, isCompleted: Bool = false, completionDate: Date? = nil, completionImageData: Data? = nil) {
        self.name = name
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.completionImageData = completionImageData
    }

    var completionImage: UIImage? {
        guard let data = completionImageData else { return nil }
        return UIImage(data: data)
    }
}
