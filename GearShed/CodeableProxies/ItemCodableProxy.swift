//
//  ItemCodable.swift
//  ShoppingList
//
//  Created by Jerry on 5/10/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import Foundation

// this is a simple struct to extract only the fields of an Item
// that we would import or export in such a way that the result is Codable
// there's some assumption here that category names are unique, because by representing
// an Item in JSON, we're asking that the item can be later hooked back up
// to its Category
struct ItemCodableProxy: Codable {
	var name: String
	var onList: Bool
	var isAvailable: Bool
	var quantity: Int
	var categoryName: String
    var brandName: String
    //var trips: NSSet
	
	init(from item: Item) {
		name = item.name
		onList = item.onList
		isAvailable = item.isAvailable
		quantity = item.weight
		categoryName = item.categoryName
        brandName = item.brandName
	}

}

