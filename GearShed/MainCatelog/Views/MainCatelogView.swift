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
    
    @State var displayBy = 1
    
    @State private var selected = 1

    //static let tag: String? = "MainCatelog"
    
    var body: some View {
            VStack(spacing: 5) {
                
                SPForShedView(selected: $selected)
                   
                if self.selected == 0 {
                    AllItemsView()
                } else if self.selected == 1 {
                    AllCategoryView()
                }
                else if self.selected == 2 {
                    AllBrandView()
                } else if self.selected == 3 {
                    AllTagView()
                } else {
                    AllWishListView()
                }
                
                
                
                Spacer()
                
                
            } // end of VStack
            .navigationBarTitle("GearShed", displayMode: .inline)
            .fullScreenCover(isPresented: $viewModel.isAddNewItemShowing){AddOrModifyItemView().environment(\.managedObjectContext, PersistentStore.shared.context)}
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

struct SPForShedView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button { self.selected = 0}
                    label: { Text("ITEM")
                        //.fontWeight(self.selected == 0 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 0 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 0 ? .white : .black)
                
                Button { self.selected = 1}
                    label: { Text("CATEGORY")
                        //.fontWeight(self.selected == 1 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 1 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 1 ? .white : .black)
                
                Button { self.selected = 2 }
                    label: { Text("BRAND")
                        //.fontWeight(self.selected == 2 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 2 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 2 ? .white : .black)
                
                Button { self.selected = 3}
                    label: { Text("TAG")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 3 ? .white : .black)
                
                Button { self.selected = 4}
                    label: { Text("WISHLIST")
                        //.fontWeight(self.selected == 4 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.fontWeight(self.selected == 4 ? .bold : .body)
                                //.background(self.selected == 4 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 4 ? .white : .black)
            }
        }
        .padding(.vertical, 10)
        .background(Color.theme.green)
        .animation(.easeInOut)
        
    }
}



/*struct Temp: View {
    
    var body: some View {
        //SearchBarView1(searchText: $viewModel.searchText)
        Rectangle()
        .frame(width: 0.01 ,height: 0.01)
        .actionSheet(isPresented: $viewModel.showDisplayAction) {
            ActionSheet(title: Text("Display:"), buttons: [
                .default(Text("All Items")) {displayBy = 0},
                .default(Text("Grouped by Category")) {displayBy = 1},
                .default(Text("Grouped by Brand")) {displayBy = 2}
            ])
        }
            .padding(.bottom, 10)
        
        if viewModel.itemsInCatelog.count == 0 {
            EmptyCatelogView()
        } else {
            ItemListDisplay(displayBy: $displayBy)
        }

        Rectangle()
            .frame(height: 1)
            .padding(.top, 5)
        
        Spacer(minLength: 80)
    }
    
    
}*/



