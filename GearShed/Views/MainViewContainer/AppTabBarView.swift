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
    
    init () {
        let appearence = UITabBarAppearance()
        
        appearence.backgroundEffect = .init(style: .systemThinMaterial)
        appearence.backgroundColor = UIColor(.theme.background)
        

        appearence.stackedLayoutAppearance.normal.iconColor = UIColor(.theme.accent)
        appearence.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.theme.accent)]

        appearence.stackedLayoutAppearance.selected.iconColor = UIColor(.theme.green)
        appearence.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.theme.green)]
        
//        appearence.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
//        appearence.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        UITabBar.appearance().standardAppearance = appearence
        
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearence
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    var body: some View {
            TabView(selection: $selection) {
                GearShedView(persistentStore: persistentStore)
                    .tabItem { Label("Gear Shed", systemImage: "house").accentColor(Color.theme.green) }
                    .tag("gearshed")
                GearlistView(persistentStore: persistentStore)
                    .tabItem { Label("Gear Lists", systemImage: "figure.walk").accentColor(Color.theme.green) }
                    .tag("gearlists")
                SettingsView(persistentStore: persistentStore)
                    .tabItem { Label("Settings", systemImage: "gear").accentColor(Color.theme.green) }
                    .tag("settings")
            }
    }
}
