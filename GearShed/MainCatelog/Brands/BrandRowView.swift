//
//  BrandRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// MARK: - BrandRowData Definition
// this is a struct to transport all the incoming data about a Brand that we
// will display.  see the commentary over in EditableItemData.swift and
// SelectableItemRowView.swift about why we do this.
struct BrandRowData {
    let name: String
    let itemCount: Int
    let order: Int
    
    init(brand: Brand) {
        name = brand.name
        itemCount = brand.itemCount
        order = brand.order
    }
}

// MARK: - BrandRowView

struct BrandRowViewOld: View {
     var rowData: BrandRowData

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(rowData.name)
                    .font(.headline)
                Text(subtitle())
                    .font(.caption)
            }
            if rowData.order != kUnknownBrandVisitationOrder {
                //Spacer()
                //Text(String(rowData.order))
            }
        } // end of HStack
    } // end of body: some View
    
    func subtitle() -> String {
        if rowData.itemCount == 1 {
            return "1 item"
        } else {
            return "\(rowData.itemCount) items"
        }
    }
    
}

struct BrandRowView: View {
    
    var brand: Brand

    var body: some View {
        
        HStack {
            NavigationLink(destination: BrandDetailView(brand: brand)) {
                HStack{
                    Text(brand.name)
                        .font(.headline)
                    Spacer()
                    Text("\(brand.itemCount)")
                        .font(.headline)
                }
            }
            
            Button {} label: {
                Image(systemName: "square.and.pencil")
            }
            
        }
        .padding(.horizontal, 20)
    }
}

struct BrandDetailView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @FetchRequest private var items: FetchedResults<Item>
    
    var brandName: Brand
    
    init(brand: Brand) {
        let request = Item.allItemsFR(at: brand)
        _items = FetchRequest(fetchRequest: request)
        self.brandName = brand
    }
    
    var body: some View {
        VStack(spacing:0) {
            StatBar2()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(items) { item in
                    ItemRowView(item: item)
                }
            }
            .padding(.top, 20)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
        }
        .navigationTitle(brandName.name)
    }
}

struct StatBar3: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Items")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Cost")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Favourites")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }

    }
}


