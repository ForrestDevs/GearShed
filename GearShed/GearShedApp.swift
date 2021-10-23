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
    
    // we create the PersistentStore here (although it will be created lazily anyway)
    @StateObject var persistentStore = PersistentStore.shared
    
    init() {
        if isFirstLaunch == true {
            Category.createUnknownCategory()
            Brand.createUnknownBrand()
            isFirstLaunch = false
        }
    }
    
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
        // when going into background, save Core Data
        persistentStore.saveContext()
    }
    
    func handleBecomeActive(_ note: Notification) {
        // when app reopens do this...
    }
}




struct TestView70: View {

    @Environment (\.presentationMode) var presentationMode

    //isFirstLaunch will default to true until it is set to false in the sheet and
    //then stored in UserDefaults
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

    var body: some View {
        VStack(spacing: 40) {
            Text("Welcome")
            Button("Reset") {
                isFirstLaunch = true
            }
            Text("is first launch? \(isFirstLaunch ? "YES" : "NO")")
        }
        .sheet(isPresented: $isFirstLaunch) {
            VStack(spacing: 40) {
                Text("Sheet")
                Button("Ok") {
                    isFirstLaunch = false
                }
            }
        }
    }
}
