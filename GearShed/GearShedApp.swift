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
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("lastReviewRequest") var lastReviewRequest: TimeInterval?
    @StateObject var persistentStore: PersistentStore
    @StateObject var unlockManager: UnlockManager
    @Environment(\.scenePhase) private var scenePhase
    
    var askForReview: Bool {
        if let lastReviewRequest = lastReviewRequest {
            let lastReviewDistance = Date().timeIntervalSinceReferenceDate - lastReviewRequest
            // Ask only every 5 days for a review
            if  lastReviewDistance < 5*24*60*60 {
                return false
            }
        }
        return true
    }

    init() {
        let persistentStore = PersistentStore()
        let unlockManager = UnlockManager(persistentStore: persistentStore)
        
        _persistentStore = StateObject(wrappedValue: persistentStore)
        _unlockManager = StateObject(wrappedValue: unlockManager)
        
        // If app is loaded for the first time - create the Unknown Brand+Shed,
        // then set to false so duplicates arent created every time.
        if isFirstLaunch == true {
            Shed.createUnknownShed()
            Brand.createUnknownBrand()
            isFirstLaunch = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabBarView()
                .environment(\.managedObjectContext, PersistentStore.shared.context)
                .environmentObject(persistentStore)
                .environmentObject(unlockManager)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                                        perform: handleResignActive)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                                        perform: handleBecomeActive)
                .onChange(of: scenePhase, perform: { newScenePhase in
                    if newScenePhase == .active && askForReview {
                        lastReviewRequest = Date().timeIntervalSinceReferenceDate
                        persistentStore.appLaunched()
                    }
                })
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

