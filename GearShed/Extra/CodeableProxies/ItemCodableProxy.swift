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
// there's some assumption here that shed names are unique, because by representing
// an Item in JSON, we're asking that the item can be later hooked back up
// to its Shed
struct ItemCodableProxy: Codable {
	var name: String
	var wishlist: Bool
	var isFavourite: Bool
    
	var quantity: Int
    var price: String
    var weight: String
    
	var shedName: String
    var brandName: String
    //var trips: NSSet
	
	init(from item: Item) {
		name = item.name
		wishlist = item.wishlist
        isFavourite = item.isFavourite
        
		quantity = item.quantity
        weight = item.weight
        price = item.price
        
		shedName = item.shedName
        brandName = item.brandName
	}

}

