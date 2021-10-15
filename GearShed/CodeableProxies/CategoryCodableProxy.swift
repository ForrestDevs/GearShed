//
//  CategoryJSON.swift
//  ShoppingList
//
//  Created by Jerry on 5/10/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import Foundation

// this is a simple struct to extract only the fields of a Category
// that we would import or export in such a way that the result is Codable
struct CategoryCodableProxy: Codable {
	var name: String
	var visitationOrder: Int
	var red: Double
	var green: Double
	var blue: Double
	var opacity: Double

	init(from category: Category) {
		name = category.name
		visitationOrder = category.visitationOrder
		red = category.red_
		green = category.green_
		blue = category.blue_
		opacity = category.opacity_
	}
}
