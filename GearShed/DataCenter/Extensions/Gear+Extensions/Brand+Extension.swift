//
//  Brand+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownBrandName = "UnBranded"
let kUnknownBrandID: Int32 = INT32_MAX
var kUnknownBrandUUID: UUID?

extension Brand: Comparable {
    // add Comparable conformance: sort by name
    public static func < (lhs: Brand, rhs: Brand) -> Bool {
        lhs.name < rhs.name
    }
    // MARK: - Computed properties
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            items.forEach({ $0.objectWillChange.send() })
        }
    }
    var unBrandID: Int {
        get { Int(unBrandID_) }
    }
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name })//.filter { !$0.wishlist }
        }
        return []
    }
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var regretItems: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name }).filter { $0.isRegret }
        }
        return []
    }
    // itemCount: computed property from Core Data items_
    var itemCount: Int { items_?.count ?? 0 }
    // simplified test of "is the unknown brand"
    var isUnknownBrand: Bool { unBrandID_ == kUnknownBrandID }
}
