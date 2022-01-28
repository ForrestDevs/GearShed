//
//  TripDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
import SwiftUI

struct GearlistDetailView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @ObservedObject private var gearlist: Gearlist
    @StateObject private var viewModel: GearlistData
    @State private var currentScreen: Int = 0
            
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
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
                    .environmentObject(viewModel)
                    .pageView()
                GearlistClusterView(gearlist: gearlist)
                    .environmentObject(viewModel)
                    .pageView()
                GearlistContainerView(gearlist: gearlist)
                    .environmentObject(viewModel)
                    .pageView()
                if gearlist.isAdventure {
                    GearlistDiaryView(gearlist: gearlist)
                        .environmentObject(viewModel)
                        .pageView()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                viewTitle
                backButtonToolBarItem
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
        }
    }
}

