//
//  OnBeatApp.swift
//  OnBeat
//
//  Created by Adrián Alejandro Ramírez Cruz on 13/11/24.
//

import SwiftUI
import SwiftData

@main
struct OnBeatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Deadline.self, TaskItem.self])
        }
    }
}
