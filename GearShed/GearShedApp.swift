//
//  GearShedApp.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-07.
//

import Foundation
import SwiftUI

@main
struct GearShedApp: App {
    
    // we create the PersistentStore here (although it will be created lazily anyway)
    @StateObject var persistentStore = PersistentStore.shared

    var body: some Scene {
        WindowGroup {
            AppTabBarView()
                .environment(\.managedObjectContext, persistentStore.context)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                                     perform: handleResignActive)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                                     perform: handleBecomeActive)
        }
    }
    
    func handleResignActive(_ note: Notification) {
        // when going into background, save Core Data and shutdown timer
        persistentStore.saveContext()
    }
    
    func handleBecomeActive(_ note: Notification) {
        // when app becomes active, restart timer if it was running previously
        // also update the meaning of Today because we may be transitioning to
        // active on a different day than when we were pushed into the background
    }
}
