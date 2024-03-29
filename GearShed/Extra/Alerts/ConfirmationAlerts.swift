//
//  ConfirmationAlerts.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//  

import SwiftUI

struct ConfirmDeleteItemAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    @State private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, item: Item, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
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
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        self.item = item
        self.gearlist = gearlist
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    var item: Item
    var gearlist: Gearlist
    var title: String { "Remove \(item.name) ?" }
    var message: String {
        "Are you sure you want to remove \(item.name) from List? This action cannot be undone"
    }
    
    func destructiveAction() {
        viewModel.removeItemFromGearlist(item: item, gearlist: gearlist)
    }
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteShedAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    @State private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, shed: Shed, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
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
    @State private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, brand: Brand, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
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
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, gearlist: Gearlist, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
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

struct ConfirmDeleteActivityTypeAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    @StateObject private var viewModel: GearlistData

    init(persistentStore: PersistentStore, type: ActivityType, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.type = type
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    var type: ActivityType
    var title: String { "Delete \(type.name) ?" }
    var message: String {
        "Are you sure you want to delete \(type.name)? All activities in \(type.name) will be deleted as well. This action cannot be undone."
    }
    func destructiveAction() {
        viewModel.deleteActivityType(type: type)
    }
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeletePileAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, pile: Pile, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        self.pile = pile
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    var pile: Pile
    var title: String { "Delete \(pile.name)?" }
    var message: String {
        "Are you sure you want to delete \(pile.name)? This action cannot be undone."
    }
    func destructiveAction() {
        viewModel.deletePile(pile: pile)
    }
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeletePackAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, container: Pack, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        self.container = container
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    var container: Pack
    var title: String { "Delete \(container.name)?" }
    var message: String {
        "Are you sure you want to delete \(container.name)? This action cannot be undone."
    }
    func destructiveAction() {
        viewModel.deletePack(container: container)
    }
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteDiaryAlert: ConfirmationAlertProtocol {
    @State private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, diary: ItemDiary, destructiveCompletion: (() -> Void)? = nil) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        self.diary = diary
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    var diary: ItemDiary
    var title: String { "Delete Diary?" }
    var message: String {
        "Are you sure you want to delete this Diary? This action cannot be undone."
    }
    func destructiveAction() {
        viewModel.deleteItemDiary(diary: diary)
    }
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}
