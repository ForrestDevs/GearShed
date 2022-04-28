//
//  CustomTabBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    
    @Binding var selection: TabBarItem
    
    @Namespace private var namespace
    
    @State var localSelection: TabBarItem
    
    var body: some View {
        tabBar
        .onChange(of: selection) { value in
            withAnimation(.easeInOut) {
                localSelection = value
            }
        }
    }
    
    private var tabBar: some View {
        VStack (spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.theme.headerBG)
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
                }
            }
            .padding(.bottom, 20)
            .padding(.top, 7)
            .background(
                Color.theme.background
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        
    }
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
            Text(tab.title)
                .formatNoColorSmall()
        }
        .foregroundColor(localSelection == tab ? Color.theme.green : Color.theme.accent)
        .frame(maxWidth: .infinity)
    }
    
    private func switchToTab(tab: TabBarItem) {
        // When switching tabs Animate to new ContentView
        withAnimation(.easeInOut) {
            selection = tab
        }
        // When Switching tabs use Jump to new contentView
        //selection = tab
    }
    
}

