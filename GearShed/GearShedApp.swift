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
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("isSystemMode") var isSystemMode: Bool = false
    
    @StateObject var persistentStore: PersistentStore
    @StateObject var unlockManager: UnlockManager
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let persistentStore = PersistentStore()
        let unlockManager = UnlockManager(persistentStore: persistentStore)
        
        _persistentStore = StateObject(wrappedValue: persistentStore)
        _unlockManager = StateObject(wrappedValue: unlockManager)
        
        if isFirstLaunch == true {
            // actions to do on first launch
            isFirstLaunch = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .transition(.opacity)
                //.preferredColorScheme(isSystemMode ? .none : isDarkMode ? .dark : .light)
                .environment(\.managedObjectContext, persistentStore.context)
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
    
    func handleResignActive(_ note: Notification) {
        // when going into background, save Core Data
        persistentStore.saveContext()
    }
    
    func handleBecomeActive(_ note: Notification) {
        // when app reopens do this...
    }
    
}
