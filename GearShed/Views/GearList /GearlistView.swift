//
//  GearlistView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct GearlistView: View {
    @StateObject private var glData: GearlistData
    @State private var currentSelection: Int = 0
    init(persistentStore: PersistentStore) {        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
    }
    var body: some View {
        NavigationView {
            PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
                Text("Adventures")
                    .formatPageHeaderTitle()
                    .pageLabel()
                Text("Activities")
                    .formatPageHeaderTitle()
                    .pageLabel()
            } content: {
                AdventureView()
                    .environmentObject(glData)
                    .pageView()
                ActivityView()
                    .environmentObject(glData)
                    .pageView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //sortByButton
                viewTitle
            }
        }
        .navigationViewStyle(.stack)
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Gear Lists")
                .formatGreen()
        }
    }
}


