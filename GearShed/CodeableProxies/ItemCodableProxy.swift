//
//  ItemCodable.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
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
    var price: String
    var weight: String
    
	var categoryName: String
    var brandName: String
    //var trips: NSSet
	
	init(from item: Item) {
		name = item.name
		onList = item.onList
		isAvailable = item.isAvailable
        
		quantity = item.quantity
        weight = item.weight
        price = item.price
        
		categoryName = item.categoryName
        brandName = item.brandName
	}

}

