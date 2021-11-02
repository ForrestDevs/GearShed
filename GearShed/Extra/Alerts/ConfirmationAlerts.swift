//
//  ConfirmationAlerts.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//  

import SwiftUI

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
/*struct ConfirmMoveAllItemsOffShoppingListAlert: ConfirmationAlertProtocol {
	var id = UUID()
	
	var title: String { "Move All Items Off-List" }
	
	var message: String { "" }
	
	func destructiveAction() {
		Item.moveAllItemsOffShoppingList()
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
}*/

// MARK: - Confirm DELETE Shed Alert
struct ConfirmDeleteShedAlert: ConfirmationAlertProtocol {
	var id = UUID()
	
	var shed: Shed
	
	var title: String { "Delete \'\(shed.name)\'?" }
	
	var message: String {
		"Are you sure you want to delete the Shed named \'\(shed.name)\'? All items at this shed will be moved to the Unknown Shed.  This action cannot be undone."
	}
	
	func destructiveAction() {
		Shed.delete(shed)
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
	
	init(shed: Shed, destructiveCompletion: (() -> Void)? = nil) {
		self.shed = shed
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

// MARK: - Confirm DELETE Tag Alert
/*struct ConfirmDeleteTagAlert: ConfirmationAlertProtocol {
    var id = UUID()
    
    var tag: Tag
    
    var title: String { "Delete \'\(tag.name)\'?" }
    
    var message: String {
        "Are you sure you want to delete the Tag named \(tag.name)? All items at this tag will be moved to the Unknown Tag.  This action cannot be undone."
    }
    
    func destructiveAction() {
        Tag.delete(tag)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    init(tag: Tag, destructiveCompletion: (() -> Void)? = nil) {
        self.tag = tag
        self.destructiveCompletion = destructiveCompletion
    }
    
}*/

// MARK: - Confirm DELETE TRIP Alert
struct ConfirmDeleteTripAlert: ConfirmationAlertProtocol {
    
    //@StateObject private var viewModel = TripsViewModel()
    
    var id = UUID()
    
    var trip: Trip
    
    var title: String { "Delete \'\(trip.name)\'?" }
    
    var message: String {
        "Are you sure you want to delete the Trip named \(trip.name)?  This action cannot be undone."
    }
    
    func destructiveAction() {
        //viewModel.deleteTrip(trip: trip)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    init(trip: Trip, destructiveCompletion: (() -> Void)? = nil) {
        self.trip = trip
        self.destructiveCompletion = destructiveCompletion
    }
    
}

// MARK: - Confirm DELETE TRIP Alert
struct ConfirmDeleteGearlistAlert: ConfirmationAlertProtocol {
    
    //@StateObject private var viewModel = TripsViewModel()
    
    var id = UUID()
    
    var gearlist: Gearlist
    
    var title: String { "Delete \'\(gearlist.name)\'?" }
    
    var message: String {
        "Are you sure you want to delete the Gearlist named \(gearlist.name)?  This action cannot be undone."
    }
    
    func destructiveAction() {
        //viewModel.deleteTrip(trip: trip)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
    
    init(gearlist: Gearlist, destructiveCompletion: (() -> Void)? = nil) {
        self.gearlist = gearlist
        self.destructiveCompletion = destructiveCompletion
    }
    
}


