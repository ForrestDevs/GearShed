//
//  CustomTabBarContainerView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct CustomTabView <Content:View>: View {
    
    let content: Content
    
    @Binding var selection: TabBarItem
    
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        /*VStack (spacing: 0) {
            content
                .frame(maxHeight: .infinity)
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }*/
        
        ZStack (alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)

        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

/*struct CustomTabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .shed, .trips, .home
    ]
    
    static var previews: some View {
        CustomTabView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}*/
