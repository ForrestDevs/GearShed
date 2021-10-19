//
//  CategoryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// MARK: - CategoryRowData Definition
// this is a struct to transport all the incoming data about a Category that we
// will display.  see the commentary over in EditableItemData.swift and
// SelectableItemRowView.swift about why we do this.
struct CategoryRowData {
	let name: String
	let itemCount: Int
	let visitationOrder: Int
	let uiColor: UIColor
	
	init(category: Category) {
		name = category.name
		itemCount = category.itemCount
		visitationOrder = category.visitationOrder
		uiColor = category.uiColor
	}
}

// MARK: - CategoryRowView

struct CategoryRowViewOld: View {
    var rowData: CategoryRowData

	var body: some View {
		HStack {
			// color bar at left (new in this code)
			Color(rowData.uiColor)
				.frame(width: 10, height: 36)
			
			VStack(alignment: .leading) {
				Text(rowData.name)
					.font(.headline)
				Text(subtitle())
					.font(.caption)
			}
			if rowData.visitationOrder != kUnknownCategoryVisitationOrder {
				//Spacer()
				//Text(String(rowData.visitationOrder))
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

struct CategoryRowView: View {
    
    var category: Category
    
    //var rowData: CategoryRowData

    var body: some View {
        
        HStack {
            NavigationLink(destination: CategoryDetailView(category: category)) {
                HStack{
                    Text(category.name)
                        .font(.headline)
                    Spacer()
                    Text("\(category.itemCount)")
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

struct CategoryDetailView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @FetchRequest private var items: FetchedResults<Item>
    
    init(category: Category) {
        let request = Item.allItemsFR(at: category)
        _items = FetchRequest(fetchRequest: request)
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
        //.navigationTitle(category.name)
    }
}

struct StatBar2: View {
    
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

