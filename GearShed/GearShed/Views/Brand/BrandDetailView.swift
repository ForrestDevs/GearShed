//
//  BrandDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct BrandDetailView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @FetchRequest private var items: FetchedResults<Item>
    
    var brandName: Brand
    
    @State var isEditBrandShowing: Bool = false
    
    init(brand: Brand) {
        let request = Item.allItemsFR(at: brand)
        _items = FetchRequest(fetchRequest: request)
        self.brandName = brand
    }
    
    var body: some View {
        VStack(spacing:0) {
            
            StatBar()
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(items) { item in
                    ItemRowView(item: item)
                }
            }
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
        }
        .navigationTitle(brandName.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: viewModel.editBrandButton)
        }
        .fullScreenCover(isPresented: $viewModel.isEditBrandShowing){ModifyBrandView(brand: brandName).environment(\.managedObjectContext, PersistentStore.shared.context)}
    }
}

struct ItemRowViewInBrand: View {

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
