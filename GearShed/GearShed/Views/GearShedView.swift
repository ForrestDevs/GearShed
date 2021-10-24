//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct MainCatelogView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @State private var selected = 1

    static let tag: String? = "MainCatelog"
    
    var body: some View {
            VStack(spacing: 5) {
                
                SPForShedView(selected: $selected)
                   
                if self.selected == 1 {
                    AllCategoryView()
                        .transition(.moveAndFade)
                }
                else if self.selected == 2 {
                    AllBrandView()
                        .transition(.moveAndFade)
                } else if self.selected == 3 {
                    AllFavouriteView()
                        .transition(.moveAndFade)
                } else if self.selected == 4 {
                    AllWishListView()
                        .transition(.moveAndFade)
                } else {
                    EmptyView()
                }
                
                Spacer()
            } // end of VStack
            .navigationBarTitle("Gear Shed", displayMode: .inline)
            .fullScreenCover(isPresented:$viewModel.isAddNewItemShowing) {
                AddItemView().environment(\.managedObjectContext, PersistentStore.shared.context)
            }
            .sheet(isPresented: $viewModel.showingUnlockView) {
                UnlockView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: viewModel.leadingButton)
                ToolbarItem(placement: .navigationBarTrailing, content: viewModel.trailingButtons)
            }
            .onAppear {
                logAppear(title: "MainCatelogView")
            }
            .onDisappear {
                logDisappear(title: "MainCatelogView")
                PersistentStore.shared.saveContext()
            }
    }
} // END OF STRUCT







