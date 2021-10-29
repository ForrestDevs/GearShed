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
    
    @State private var tabSelection: TabBarItem = .home
    
    // Current Tab...
    @State var currentTab = "GearShed"
    
    var bottomEdge: CGFloat
    
    // Hiding Native TabBar...
    init(bottomEdge: CGFloat){
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
    }
    
    @State var hideBar = false
    
    var body: some View {
        
        TabView(selection: $currentTab) {
        
            NavigationView { HomeView() }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("Home")
            
            NavigationView { GearShedView(hideTab: $hideBar, bottomEdge: bottomEdge, persistentStore: persistentStore) }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("GearShed")
            
            NavigationView { GearlistView(persistentStore: persistentStore) }
                .frame(maxWidth: .infinity ,maxHeight: .infinity)
                .tag("Gearlist")
            
        }
        .overlay(
            CustomTabBar(currentTab: $currentTab,bottomEdge: bottomEdge)
                .offset(y: hideBar ? (50 + bottomEdge) : 0) ,alignment: .bottom
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

/*struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}*/


/*CustomTabView(selection: $tabSelection) {

    NavigationView { HomeView() }
        .tabBarItem(tab: .home, selection: $tabSelection)
    
    NavigationView { GearShedView(persistentStore: persistentStore) }
        .tabBarItem(tab: .shed, selection: $tabSelection)
    
    NavigationView { GearlistView(persistentStore: persistentStore) }
        .tabBarItem(tab: .trips, selection: $tabSelection)
    
}*/

/*struct AppTabBarView1: View {

    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        NavigationView{
            CustomTabView(selection: $tabSelection) {
            
                HomeView()
                    .offset(y: 50)
                    .tabBarItem(tab: .home, selection: $tabSelection)
                    .tag(TabBarItem.home)
                
                MainCatelogView()
                    .offset(y: 100)
                    .tabBarItem(tab: .shed, selection: $tabSelection)
                    .tag(TabBarItem.shed)

                                
                TripsTabView()
                    .offset(y: 100)
                    .tabBarItem(tab: .trips, selection: $tabSelection)
                    .tag(TabBarItem.trips)

                
            }
            //.navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))
            //.navigationViewStyle(StackNavigationViewStyle())
        }

    }

        
    func returnNaviBarTitle(tabSelection: TabBarItem) -> String {
        switch tabSelection {
            case .home: return "Tab1"
            case .shed: return "Tab2"
            case .trips: return "Tab2"
        }
    }
}

struct AppTabBarView2: View {

    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            NavigationView { HomeView() }
                .tabItem({ Label("Home", systemImage: "list.bullet") })

               
            NavigationView { MainCatelogView() }
                .tabItem({ Label("Gear Shed", systemImage: "house") })

            NavigationView { TripsTabView() }
                .tabItem({ Label("Gear List", systemImage: "figure.walk") })

        }
    }
}*/

