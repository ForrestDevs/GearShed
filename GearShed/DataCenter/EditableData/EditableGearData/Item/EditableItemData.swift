//
//  EditableItemData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

struct EditableItemData {
    let persistentStore: PersistentStore
    var id: UUID?
    var name: String
    var weight: String
    var lbs: String
    var oz: String
    var price: String
    var quantity: Int
    var details: String
    var shed: Shed?
    var brand: Brand?
    var isWishlist: Bool
    var isFavourite: Bool
    var isRegret: Bool
    var datePurchased: Date?
    /// To  save/commit an Item, it must have a non-empty name, shed and brand.
    var canBeSaved: Bool { name.count > 0 && shed != nil && brand != nil }
    /// If the item has an ID then the item has already been created and exists in CoreData Store.
    var representsExistingItem: Bool { id != nil }
    /// The associated Item with the ID and in the context. Only call on Existing Items only.
    var associatedItem: Item { Item.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableItemData {
    /// Initializer for loading current Item details for Modify Item View.
    init(persistentStore: PersistentStore, item: Item) {
        self.persistentStore = persistentStore
        self.id = item.id
        self.name = item.name
        self.weight = item.weight
        self.lbs = item.itemLbs
        self.oz = item.itemOZ
        self.price = item.price
        self.quantity = item.quantity
        self.details = item.detail
        self.shed = item.shed
        self.brand = item.brand
        self.isWishlist = item.isWishlist
        self.isFavourite = item.isFavourite
        self.isRegret = item.isRegret
        self.datePurchased = item.datePurchased ?? nil
    }
    /// Initializer for loading a new Item with shed Passed In
    init(persistentStore: PersistentStore, shedInEdit: Shed) {
        self.persistentStore = persistentStore
        self.name = ""
        self.weight = ""
        self.lbs = ""
        self.oz = ""
        self.price = ""
        self.quantity = 1
        self.details = ""
        self.shed = shedInEdit
        self.brand = nil
        self.isWishlist = false
        self.isFavourite = false
        self.isRegret = false
        self.datePurchased = nil
    }
    /// Initializer for loading a new Item with shed Passed In
    init(persistentStore: PersistentStore, brandInEdit: Brand) {
        self.persistentStore = persistentStore
        self.name = ""
        self.weight = ""
        self.lbs = ""
        self.oz = ""
        self.price = ""
        self.quantity = 1
        self.details = ""
        self.shed = nil
        self.brand = brandInEdit
        self.isWishlist = false
        self.isFavourite = false
        self.isRegret = false
        self.datePurchased = nil
    }
    /// Initializer for loading a new Item wishlist passed In.
    init(persistentStore: PersistentStore, wishlistInEdit: Bool) {
        self.persistentStore = persistentStore
        self.name = ""
        self.weight = ""
        self.lbs = ""
        self.oz = ""
        self.price = ""
        self.quantity = 1
        self.details = ""
        self.shed = nil
        self.brand = nil
        self.isWishlist = wishlistInEdit
        self.isFavourite = false
        self.isRegret = false
        self.datePurchased = nil
    }
    /// Initializer for standard add Item
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
        self.weight = ""
        self.lbs = ""
        self.oz = ""
        self.price = ""
        self.quantity = 1
        self.details = ""
        self.shed = nil
        self.brand = nil
        self.isWishlist = false
        self.isFavourite = false
        self.isRegret = false
        self.datePurchased = nil
    }
}
