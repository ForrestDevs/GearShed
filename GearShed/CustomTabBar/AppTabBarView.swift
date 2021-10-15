//
//  AppTabBarView.swift
//  GearShedV1
//
//  Created by Luke Forrest Gannon on 2021-10-13.
//

import SwiftUI

// Generics
// ViewBuilder
// PreferenceKey
// Matched Geometry Effect

struct AppTabBarView: View {

    @State private var tabSelection: TabBarItem = .shed
    
    var body: some View {
        CustomTabView(selection: $tabSelection) {
            
            NavigationView { MainCatelogView() }
                .tabBarItem(tab: .shed, selection: $tabSelection)
            
            NavigationView { TripsTabView() }
                .tabBarItem(tab: .trips, selection: $tabSelection)
            
            NavigationView { PreferencesTabView() }
                .tabBarItem(tab: .settings, selection: $tabSelection)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AppTabBarView_Previews: PreviewProvider {    
    static var previews: some View {
        AppTabBarView()
    }
}

