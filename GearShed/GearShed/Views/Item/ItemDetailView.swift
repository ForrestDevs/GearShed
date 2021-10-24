//
//  ItemDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject  private var viewModel = MainCatelogVM()
        
    @State private var selected = 1
    
    @State private var regret: Bool = false
    
    var item: Item

    var body: some View {
        VStack (alignment: .leading) {
            
            VStack {
                // Fav, Brand, Name
                HStack {
                    
                    Image(systemName: item.isFavourite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 13, height: 12)
                        .foregroundColor(Color.theme.green)
                        .padding(.vertical, -1)
                    
                    Text(item.brandName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.theme.green)
                    Text(item.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.theme.green)
                    
                    Spacer()

                }
                
                HStack {
                    
                    VStack (alignment: .leading) {
                        // Price + Weight
                        HStack {
                            Text("10g")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                            
                            Text("$100")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                        }
                       
                        // Regret Toggle
                        Toggle("Regret",isOn: $regret)
                            .toggleStyle(CheckmarkToggleStyle())
                    }
                    .padding(.horizontal,20)
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.gray)
                }
                
            }
            .padding(.horizontal)
            
            SPForDetailView(selected: $selected)
            
            if self.selected == 1 {
                Color.black
                    .transition(.moveAndFade)
            }
            else if self.selected == 2 {
                Color.black
                    .transition(.moveAndFade)
            } else if self.selected == 3 {
                Color.black
                    .transition(.moveAndFade)
            } else {
                Color.black
                    .transition(.moveAndFade)
            }
            
            Spacer()
        }
        .navigationTitle("\(item.categoryName)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: viewModel.editItemButton)
        }
        .fullScreenCover(isPresented: $viewModel.isEditItemShowing){ModifyItemView(editableItem: item).environment(\.managedObjectContext, PersistentStore.shared.context)}
    }
}

