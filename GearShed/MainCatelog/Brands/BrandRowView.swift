//
//  BrandRowView.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-09-30.
//  Copyright © 2021 Jerry. All rights reserved.
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

struct BrandRowView: View {
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

