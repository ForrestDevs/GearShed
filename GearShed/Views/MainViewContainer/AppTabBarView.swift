//
//  AppTabBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AppTabBarView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @State private var selection: String = "gearshed"
    @State private var tabSelection: TabBarItem = .gearshed
    
    var body: some View {
        CustomTabView(selection: $tabSelection) {
            GearShedView(persistentStore: persistentStore)
                .tabBarItem(tab: .gearshed, selection: $tabSelection)
            GearlistView(persistentStore: persistentStore)
                .tabBarItem(tab: .gearlist, selection: $tabSelection)
            SettingsView(persistentStore: persistentStore)
                .tabBarItem(tab: .settings, selection: $tabSelection) 
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
