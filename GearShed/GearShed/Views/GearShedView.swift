//
//  GearShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearShedView: View {
    static let tag: String? = "GearShed"
    
    var bottomEdge: CGFloat
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var currentSelection: Int = 0

    init(bottomEdge: CGFloat, persistentStore: PersistentStore) {
        self.bottomEdge = bottomEdge
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        PagerTabView(tint: Color.theme.accent,selection: $currentSelection) {
            HStack(spacing: 0) {
                Text("ITEM")
                    .pageLabel()
                    .font(.system(size: 12).bold())
                
                Text("SHED")
                    .pageLabel()
                    .font(.system(size: 12).bold())

                Text("BRAND")
                    .pageLabel()
                    .font(.system(size: 12).bold())
                
                Text("WISH")
                    .pageLabel()
                    .font(.system(size: 12).bold())
                
                Text("FAV")
                    .pageLabel()
                    .font(.system(size: 12).bold())

                Text("REGRET")
                    .pageLabel()
                    .font(.system(size: 12).bold())
            }
        }
        content: {
            AllItemsView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllShedView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllBrandView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllWishListView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllFavouriteView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllRegretsView(bottomEdge: bottomEdge, persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
        }
        .padding(.top, 10)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("Gear Shed", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: viewModel.leadingButton)
        }
        .onAppear {
            logAppear(title: "MainCatelogView")
        }
        .onDisappear {
            logDisappear(title: "MainCatelogView")
            PersistentStore.shared.saveContext()
        }
    }
}

/*ToolbarItem(placement: .navigationBarTrailing) {
    Button {
        hideTab.toggle()
    } label: {
        Text("Hide Tab")
    }
}*/







