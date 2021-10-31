//
//  TableData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-31.
//

import Foundation

struct TableData {
    let name: String
    let detail: String
    let brand: String
    let shed: String
    let price: String
    let weight: String
    
    init(name: String, detail: String, brand: String, shed: String, price: String, weight: String) {
        self.name = name
        self.detail = detail
        self.brand = brand
        self.shed = shed
        self.price = price
        self.weight = weight
    }
}
