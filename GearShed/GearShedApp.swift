//
//  GearShedApp.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI

@main
struct GearShedApp: App {
    
    // we create the PersistentStore here (although it will be created lazily anyway)
    @StateObject var persistentStore = PersistentStore.shared

    var body: some Scene {
        WindowGroup {
            
            //Test3()
            
                AppTabBarView()
                    .environment(\.managedObjectContext, persistentStore.context)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                                         perform: handleResignActive)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                                         perform: handleBecomeActive)
            
            
            
            
        }
    }
    
    func handleResignActive(_ note: Notification) {
        // when going into background, save Core Data
        persistentStore.saveContext()
    }
    
    func handleBecomeActive(_ note: Notification) {
        // when app reopens do this...
        
    }
}
