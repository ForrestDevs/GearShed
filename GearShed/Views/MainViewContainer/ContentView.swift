//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var detailManager: DetailViewManager
    
    init() {
        let detailManager = DetailViewManager()
        _detailManager = StateObject(wrappedValue: detailManager)
    }
    
    var body: some View {
        AppTabBarView()
            .environmentObject(detailManager)
            .ignoresSafeArea(.all, edges: .bottom)
        
            .overlay(detailManager.showGearlistDetail ? detailManager.content.animation(.default, value: detailManager.showGearlistDetail) : nil)
        
            .overlay(detailManager.showAddNewGearlist ? detailManager.content.animation(.default, value: detailManager.showAddNewGearlist) : nil)
        
            .overlay(detailManager.showRangeDatePicker ? detailManager.secondaryContent.animation(.default, value: detailManager.showRangeDatePicker) : nil)
        
            .overlay(detailManager.showSelectGearlistItems ? detailManager.content.animation(.default, value: detailManager.showSelectGearlistItems) : nil)
    }
}






