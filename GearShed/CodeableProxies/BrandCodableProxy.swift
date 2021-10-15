//
//  BrandCodableProxy.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-09-30.
//  
//

import Foundation

// this is a simple struct to extract only the fields of a Category
// that we would import or export in such a way that the result is Codable
struct BrandCodableProxy: Codable {
    var name: String
    var order: Int

    init(from brand: Brand) {
        name = brand.name
        order = brand.order
    }
}
