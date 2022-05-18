//
//  GearlistDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct GearlistDetailView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @ObservedObject private var gearlist: Gearlist
    @StateObject private var glData: GearlistData
    @State private var currentScreen: Int = 0
            
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        self.gearlist = gearlist
    }
    
    var body: some View {
        NavigationView {
            PagerTabView(tint: Color.theme.accent, selection: $currentScreen) {
                Text("List")
                    .formatPageHeaderTitle()
                    .pageLabel()
                Text("Pile")
                    .formatPageHeaderTitle()
                    .pageLabel()
                Text("Pack")
                    .formatPageHeaderTitle()
                    .pageLabel()
                if gearlist.isAdventure {
                    Text("Diary")
                        .formatPageHeaderTitle()
                        .pageLabel()
                }
            } content: {
                GearlistItemListView(gearlist: gearlist)
                    .environmentObject(glData)
                    .pageView()
                GearlistPileView(gearlist: gearlist)
                    .environmentObject(glData)
                    .pageView()
                GearlistPackView(gearlist: gearlist)
                    .environmentObject(glData)
                    .pageView()
                if gearlist.isAdventure {
                    GearlistDiaryView(gearlist: gearlist)
                        .environmentObject(glData)
                        .pageView()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                backButtonToolBarItem
                viewTitle
                shareList
            }
        }
        .transition(.move(edge: .trailing))
    }
    // MARK: Toolbar Content
    private var backButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(gearlist.name)
                .formatGreen()
                .lineLimit(1)
        }
    }
    private var shareList: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                glData.printPDF(selectedGearlist: gearlist, pdfInt: currentScreen)
            } label: {
                Text("PDF")
            }
        }
    }
}

