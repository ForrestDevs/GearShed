//
//  TripsTabView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistView: View {
    static let tag: String? = "GearList"
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearlistData
    
    @State private var currentSelection: Int = 0
        
    init(persistentStore: PersistentStore) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AllGearLists(persistentStore: persistentStore)
        /*PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
            Text("PERSONAL LIST")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("GENARIC LIST")
                .pageLabel()
                .font(.system(size: 12).bold())
        } content: {
            AllGearLists(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
                
            EmptyTripView()
                .pageView(ignoresSafeArea: true, edges: .bottom)
        }*/
        .padding(.top, 10)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("Gear List", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .onDisappear() {
            persistentStore.saveContext()
        }
    }
}



