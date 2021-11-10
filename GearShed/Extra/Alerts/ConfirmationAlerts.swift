//
//  ConfirmationAlerts.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//  

import SwiftUI

struct ConfirmDeleteItemAlert: ConfirmationAlertProtocol {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, item: Item, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.item = item
        self.destructiveCompletion = destructiveCompletion
    }
    
	var id = UUID()
	
	var item: Item
	
	var title: String { "Delete \(item.name)?" }
	
	var message: String {
		"Are you sure you want to delete \(item.name)? This action cannot be undone"
	}
	
	func destructiveAction() {
        viewModel.deleteItem(item: item)
	}
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmRemoveItemFromListAlert: ConfirmationAlertProtocol {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, item: Item, listGroup: ListGroup, packingGroup: PackingGroup?, destructiveCompletion: (() -> Void)? = nil) {
        self.item = item
        self.listGroup = listGroup
        self.packingGroup = packingGroup
        self.destructiveCompletion = destructiveCompletion
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var id = UUID()
    
    var item: Item
    
    var listGroup: ListGroup
    
    var packingGroup: PackingGroup?
    
    var title: String { "Remove \(item.name) ?" }
    
    var message: String {
        "Are you sure you want to remove \(item.name) from List? This action cannot be undone"
    }
    
    func destructiveAction() {
        viewModel.removeItemFromList(item: item, listGroup: listGroup, packingGroup: packingGroup)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteShedAlert: ConfirmationAlertProtocol {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, shed: Shed, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.shed = shed
        self.destructiveCompletion = destructiveCompletion
    }
    
	var id = UUID()
	
	var shed: Shed
	
	var title: String { "Delete \(shed.name)?" }
	
	var message: String {
		"Are you sure you want to delete \(shed.name)? All items at this shed will be moved to the Unknown Shed. This action cannot be undone."
	}
	
	func destructiveAction() {
        viewModel.deleteShed(shed: shed)
    }
	
	var destructiveCompletion: (() -> Void)?
	var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteBrandAlert: ConfirmationAlertProtocol {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, brand: Brand, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.brand = brand
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    
    var brand: Brand
    
    var title: String { "Delete \(brand.name)?" }
    
    var message: String {
        "Are you sure you want to delete \(brand.name)? All items at this brand will be moved to the Unknown Brand. This action cannot be undone."
    }
    
    func destructiveAction() {
        viewModel.deleteBrand(brand: brand)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteGearlistAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, gearlist: Gearlist, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.gearlist = gearlist
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    
    var gearlist: Gearlist
    
    var title: String { "Delete \(gearlist.name)?" }
    
    var message: String {
        "Are you sure you want to delete \(gearlist.name)? This action cannot be undone."
    }
    
    func destructiveAction() {
        viewModel.deleteGearlist(gearlist: gearlist)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}
