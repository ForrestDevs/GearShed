//
//  AppTabBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AppTabBarView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager
    
    // Current Tab...
    @State var currentTab = "GearShed"
    
    var bottomEdge: CGFloat
    
    // Hiding Native TabBar...
    init(bottomEdge: CGFloat){
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView { HomeView() }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("Home")
            
            NavigationView { GearShedView(persistentStore: persistentStore) }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("GearShed")
            
            NavigationView { GearlistView(persistentStore: persistentStore) }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("Gearlist")
        }
        .overlay(
            CustomTabBar(currentTab: $currentTab)
                .offset(y: tabManager.hideTab ? (50 + bottomEdge) : 0) ,alignment: .bottom
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



