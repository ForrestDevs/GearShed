//
//  CategoryDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @FetchRequest private var items: FetchedResults<Item>
    
    var categoryName: Category
    
    init(category: Category) {
        let request = Item.allItemsFR(at: category)
        _items = FetchRequest(fetchRequest: request)
        self.categoryName = category
    }
    
    var body: some View {
        VStack(spacing:0) {
            
            StatBar1()
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(items) { item in
                    ItemRowView(item: item)
                }
            }
            //.padding(.top, 20)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
                
        }
        .navigationTitle(categoryName.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: viewModel.editCategoryButton)
        }
        .fullScreenCover(isPresented: $viewModel.isEditCategoryShowing){ModifyCategoryView(category: categoryName).environment(\.managedObjectContext, PersistentStore.shared.context)}
        
    }
}

struct ItemRowViewInCategory: View {

    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            HStack {
                Image(systemName: "square.fill")
                    .resizable()
                    .font(.title)
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.theme.background)
                    .padding(.horizontal,4)
                
                // Name, Brand, Details
                VStack (alignment: .leading) {
                    
                    HStack {
                        Text(item.brandName)
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("|")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text(item.name)
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack {
                    // quantity at the right
                    Text("\(item.weight) g")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.theme.green)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
    
}



