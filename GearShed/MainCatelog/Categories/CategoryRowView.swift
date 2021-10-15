//
//  CategoryRowView.swift
//  ShoppingList
//
//  Created by Jerry on 6/1/20.
//  Copyright © 2020 Jerry. All rights reserved.
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

struct CategoryRowView: View {
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
