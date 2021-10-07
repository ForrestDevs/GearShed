//
//  GearShedApp.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-07.
//

import SwiftUI

@main
struct GearShedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
