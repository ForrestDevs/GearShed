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
        
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var currentSelection: Int = 0
    
    @State private var showPDFScreen: Bool = false

    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        PagerTabView(tint: Color.theme.accent,selection: $currentSelection) {
            Text("ITEM")
                .pageLabel()
                .font(.system(size: 12).bold())
                
            Text("BRAND")
                .pageLabel()
                .font(.system(size: 12).bold())
            
            Text("SHED")
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
        } content: {
            AllItemsView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllBrandView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllShedView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllWishListView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllFavouriteView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            AllRegretsView(persistentStore: persistentStore)
                .pageView(ignoresSafeArea: true, edges: .bottom)
        }
        .padding(.top, 10)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("Gear Shed", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showPDFScreen.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .fullScreenCover(isPresented: $showPDFScreen) {
            NavigationView {
                PDFExportView(persistentStore: persistentStore)
            }
        }
        .onDisappear {
            persistentStore.saveContext()
        }
    }
}





