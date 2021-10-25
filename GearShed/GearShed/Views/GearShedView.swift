//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct MainCatelogView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: MainCatelogVM
    
    @State private var selected = 1

    static let tag: String? = "MainCatelog"
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            VStack(spacing: 5) {
                
                SPForShedView(selected: $selected)
                   
                if self.selected == 1 {
                    AllCategoryView(persistentStore: persistentStore)
                        .transition(.moveAndFade)
                }
                else if self.selected == 2 {
                    AllBrandView(persistentStore: persistentStore)
                        .transition(.moveAndFade)
                } else if self.selected == 3 {
                    AllFavouriteView(persistentStore: persistentStore)
                        .transition(.moveAndFade)
                } else if self.selected == 4 {
                    AllWishListView(persistentStore: persistentStore)
                        .transition(.moveAndFade)
                } else {
                    EmptyView()
                }
                
                Spacer()
            } // end of VStack
            .navigationBarTitle("Gear Shed", displayMode: .inline)
            .fullScreenCover(isPresented:$viewModel.isAddNewItemShowing) {
                AddItemView(persistentStore: persistentStore).environment(\.managedObjectContext, PersistentStore.shared.context)
            }
            .sheet(isPresented: $viewModel.showingUnlockView) {
                UnlockView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: viewModel.leadingButton)
                ToolbarItem(placement: .navigationBarTrailing, content: viewModel.trailingButton)
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







