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
    
    var item: Item

    var body: some View {
        VStack (alignment: .leading) {
            
            HStack {
                Text(item.brandName)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.green)
                Text(item.name)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.green)

            }
            
            Text(item.categoryName)
                .font(.caption)
                       
            StatBar1()
            
            //SPForDetailView(selected: $selected)
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: viewModel.editItemButton)
        }
        .fullScreenCover(isPresented: $viewModel.isEditItemShowing){ModifyItemView(editableItem: item).environment(\.managedObjectContext, PersistentStore.shared.context)}
    }
}

struct SPForDetailView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button { self.selected = 0}
                    label: { Text("A ... Z")
                                .padding(.vertical,12)
                                .padding(.horizontal,30)
                                .background(self.selected == 0 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                }
                .foregroundColor(self.selected == 0 ? .green : .black)
                
                Button { self.selected = 1 }
                    label: { Text("FAVOURITES")
                                .padding(.vertical,12)
                                .padding(.horizontal,30)
                                .background(self.selected == 1 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                }
                .foregroundColor(self.selected == 1 ? .green : .black)
                
            }
        }
        .padding(5)
        .background(Color.secondary)
        .animation(.easeInOut)
        
    }
}
