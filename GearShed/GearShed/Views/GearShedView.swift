//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct MainCatelogView: View {
    static let tag: String? = "MainCatelog"
    @EnvironmentObject var persistentStore: PersistentStore
    @StateObject private var viewModel: MainCatelogVM
    @State var currentSelection: Int = 0

    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            
            PagerTabView(tint: Color.theme.accent,selection: $currentSelection) {
                HStack(spacing: 0) {
                    Text("ALL")
                        .pageLabel()
                        .font(.system(size: 12).bold())
                    
                    Text("SHED")
                        .pageLabel()
                        .font(.system(size: 12).bold())

                    Text("BRAND")
                        .pageLabel()
                        .font(.system(size: 12).bold())

                    Text("FAV")
                        .pageLabel()
                        .font(.system(size: 12).bold())

                    Text("WISH")
                        .pageLabel()
                        .font(.system(size: 12).bold())

                    Text("REGRET")
                        .pageLabel()
                        .font(.system(size: 12).bold())
                }
            } content: {
                AllItemsView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                
                AllShedView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                
                AllBrandView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                
                AllFavouriteView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                
                AllWishListView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                
                AllRegretsView(persistentStore: persistentStore)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
            }
            .padding(.top)
            .ignoresSafeArea(.container, edges: .bottom)
        }
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


/*SPForShedView(selected: $selected)
if self.selected == 0 {
    AllItemsView(persistentStore: persistentStore)
        .transition(.moveAndFade)
} else if self.selected == 1 {
    AllShedView(persistentStore: persistentStore)
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
}*/

//Spacer()






