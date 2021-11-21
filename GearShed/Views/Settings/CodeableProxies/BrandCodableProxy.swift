//
//  BrandCodableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//  
//

import Foundation

extension Brand: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return BrandCodableProxy(from: self)
    }
}

struct BrandCodableProxy: Codable {
    var id: String
    var name: String
    var items = [String]()

    init(from brand: Brand) {
        self.id = brand.id!.uuidString
        self.name = brand.name
        
        for item in brand.items {
            self.items.append(item.id!.uuidString)
        }
    }
}
