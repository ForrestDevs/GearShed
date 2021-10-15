//
//  ConfirmationAlerts.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  

import SwiftUI

// i collect all the confirmation alerts here in one file.  there are four of them, although
// two of them are used in different places throughout the app; that's why they are all
// here and not distributed in different Views.
//
// please be sure to read through the file ConfirmationAlertProtocol.swift that describes
// how to set up alerts.

// MARK: - Confirm DELETE ITEM Alert
struct ConfirmDeleteItemAlert: ConfirmationAlertProtocol {
	var id = UUID()
	
	var item: Item
	
	var title: String { "Delete \'\(item.name)\'?" }
	
	var message: String {
		"Are you sure you want to delete the Item named \'\(item.name)\'? This action cannot be undone"
	}
	
	func destructiveAction() {
		Item.delete(item)
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
	
	init(item: Item, destructiveCompletion: (() -> Void)? = nil) {
		self.item = item
		self.destructiveCompletion = destructiveCompletion
	}
}

// MARK: - Confirm MOVE ALL ITEMS OF LIST Alert
struct ConfirmMoveAllItemsOffShoppingListAlert: ConfirmationAlertProtocol {
	var id = UUID()
	
	var title: String { "Move All Items Off-List" }
	
	var message: String { "" }
	
	func destructiveAction() {
		Item.moveAllItemsOffShoppingList()
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
}

// MARK: - Confirm DELETE Category Alert
struct ConfirmDeleteCategoryAlert: ConfirmationAlertProtocol {
	var id = UUID()
	
	var category: Category
	
	var title: String { "Delete \'\(category.name)\'?" }
	
	var message: String {
		"Are you sure you want to delete the Category named \'\(category.name)\'? All items at this category will be moved to the Unknown Category.  This action cannot be undone."
	}
	
	func destructiveAction() {
		Category.delete(category)
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
	
	init(category: Category, destructiveCompletion: (() -> Void)? = nil) {
		self.category = category
		self.destructiveCompletion = destructiveCompletion
	}
	
}

// MARK: - Confirm DELETE BRAND Alert
struct ConfirmDeleteBrandAlert: ConfirmationAlertProtocol {
    var id = UUID()
    
    var brand: Brand
    
    var title: String { "Delete \'\(brand.name)\'?" }
    
    var message: String {
        "Are you sure you want to delete the Brand named \'\(brand.name)\'? All items at this brand will be moved to the Unknown Brand.  This action cannot be undone."
    }
    
    func destructiveAction() {
        Brand.delete(brand)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    init(brand: Brand, destructiveCompletion: (() -> Void)? = nil) {
        self.brand = brand
        self.destructiveCompletion = destructiveCompletion
    }
    
}

// MARK: - Confirm DELETE TRIP Alert
struct ConfirmDeleteTripAlert: ConfirmationAlertProtocol {
    var id = UUID()
    
    var trip: Trip
    
    var title: String { "Delete \'\(trip.name)\'?" }
    
    var message: String {
        "Are you sure you want to delete the Brand named \'\(trip.name)\'? All items at this brand will be moved to the Unknown Brand.  This action cannot be undone."
    }
    
    func destructiveAction() {
        Trip.delete(trip)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    init(trip: Trip, destructiveCompletion: (() -> Void)? = nil) {
        self.trip = trip
        self.destructiveCompletion = destructiveCompletion
    }
    
}

