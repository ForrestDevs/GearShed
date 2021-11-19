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
        self.item = item
        self.gearlist = gearlist
        self.destructiveCompletion = destructiveCompletion
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
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


struct ConfirmDeleteClusterAlert: ConfirmationAlertProtocol {
    @EnvironmentObject var persistentStore: PersistentStore
    
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, cluster: Cluster, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        
        self.cluster = cluster
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    
    var cluster: Cluster
    
    var title: String { "Delete \(cluster.name)?" }
    
    var message: String {
        "Are you sure you want to delete \(cluster.name)? This action cannot be undone."
    }
    
    func destructiveAction() {
        viewModel.deleteCluster(cluster: cluster)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}

struct ConfirmDeleteContainerAlert: ConfirmationAlertProtocol {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @State private var viewModel: GearlistData
    
    init(persistentStore: PersistentStore, container: Container, destructiveCompletion: (() -> Void)? = nil) {
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = State(wrappedValue: viewModel)
        
        self.container = container
        self.destructiveCompletion = destructiveCompletion
    }
    
    var id = UUID()
    
    var container: Container
    
    var title: String { "Delete \(container.name)?" }
    
    var message: String {
        "Are you sure you want to delete \(container.name)? This action cannot be undone."
    }
    
    func destructiveAction() {
        viewModel.deleteContainer(container: container)
    }
    
    var destructiveCompletion: (() -> Void)?
    var nonDestructiveCompletion: (() -> Void)?
}
