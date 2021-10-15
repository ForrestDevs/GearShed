//
//  CustomTabBarContainerView.swift
//  GearShedV1
//
//  Created by Luke Forrest Gannon on 2021-10-13.
//

import SwiftUI

struct CustomTabView <Content:View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack (alignment: .bottom){
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)

        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .shed, .trips, .settings
    ]
    
    static var previews: some View {
        CustomTabView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
