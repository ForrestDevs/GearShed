//
//  CategoryJSON.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation

// this is a simple struct to extract only the fields of a Category
// that we would import or export in such a way that the result is Codable
struct CategoryCodableProxy: Codable {
	var name: String

	init(from category: Category) {
		name = category.name
	}
}
