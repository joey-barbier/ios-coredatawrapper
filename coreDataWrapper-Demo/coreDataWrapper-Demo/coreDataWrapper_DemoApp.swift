//
//  coreDataWrapper_DemoApp.swift
//  coreDataWrapper-Demo
//
//  Created by Joey BARBIER on 19/07/2022.
//

import SwiftUI
import OrkaCoreDataWrapper

@main
struct coreDataWrapper_DemoApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        // MARK: - 1) Configure CoreData context
        CoreDataConfig.init(with: persistenceController.container)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
