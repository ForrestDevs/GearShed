//
//  BrandCodableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//  
//

import Foundation

// this is a simple struct to extract only the fields of a Category
// that we would import or export in such a way that the result is Codable
struct BrandCodableProxy: Codable {
    var name: String

    init(from brand: Brand) {
        name = brand.name
    }
}
