//
//  Shed+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownShedName = "Uncategorized"
let kUnknownShedID: Int32 = INT32_MAX

extension Shed: Comparable {
	// add Comparable conformance: sort by name
	public static func < (lhs: Shed, rhs: Shed) -> Bool {
		lhs.name < rhs.name
	}
	// MARK: - Computed properties
	var name: String {
		get { name_ ?? "Unknown Name" }
		set { name_ = newValue }
	}
    var unShedID: Int {
        get { Int(unShedID_) }
    }
	// items: fronts Core Data attribute items_ that is an NSSet, and turns it into
	// a Swift array
	var items: [Item] {
		if let items = items_ as? Set<Item> {
            // returns an array of items sorted by name and filtering out any wishList Items
            return items.sorted(by: { $0.name < $1.name })//.filter { !$0.wishlist }
		}
		return []
	}
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var regretItems: [Item] {
        if let items = items_ as? Set<Item> {
            // returns an array of items sorted by name and filtering out any wishList Items
            return items.sorted(by: { $0.name < $1.name }).filter { $0.isRegret }
        }
        return []
    }
    var favItems: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name }).filter { $0.isFavourite }
        }
        return []
    }
    var wishItems: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name }).filter { $0.isWishlist }
        }
        return []
    }
	// itemCount: computed property from Core Data items_
	var itemCount: Int { items_?.count ?? 0 }
	// simplified test of "is the unknown shed"
	var isUnknownShed: Bool { name_ == kUnknownShedName }
}
