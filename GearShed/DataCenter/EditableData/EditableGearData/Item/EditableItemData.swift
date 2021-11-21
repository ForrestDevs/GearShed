//
//  EditableItemData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation

struct EditableItemData {
    
    let persistentStore: PersistentStore
    
    var id: UUID?
    var name: String
    var weight: String
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

/*struct EditableItemData {
    
    let persistentStore: PersistentStore
    
    var id: UUID? = nil
    
    var name: String = ""
    var weight: String = ""
    var price: String = ""
    var quantity: Int = 1
    var details: String = ""
    var shed: Shed?
    var brand: Brand?
    var wishlist: Bool = false
    var isFavourite: Bool = false
    var isRegret: Bool = false
    
    var datePurchased: Date = Date()
    
    init(persistentStore: PersistentStore, item: Item) {
        self.persistentStore = persistentStore
        
        id = item.id
        name = item.name
        
        weight = item.weight
        price = item.price
        quantity = item.quantity
        
        details = item.detail
        
        shed = item.shed
        brand = item.brand
        
        wishlist = item.wishlist
        isFavourite = item.isFavourite
        isRegret = item.isRegret
        
        datePurchased = item.datePurchased
        
    }
    
    // Init for loading intial values passed in
    init(persistentStore: PersistentStore, shedInEdit: Shed?, wishlistInEdit: Bool?) {
        self.persistentStore = persistentStore

        if shedInEdit != nil {
            shed = shedInEdit!
        }
        
        if wishlistInEdit != nil {
            wishlist = wishlistInEdit!
        }
        /*if let shed = shedInEdit {
            self.shed = shed
        }*/
        /*if let wishlist = wishlist {
            self.wishlist = wishlist
        }*/
    }
    
    // to do a save/commit of an Item, it must have a non-empty name shed and brand
    var canBeSaved: Bool {
        name.count > 0 && shed != nil && brand != nil
    }
    // we also want to know if this itemData is attached to a real Item that
    // exists, or is data that will be used to create a new Item
    var representsExistingItem: Bool { id != nil }
    // useful to know the associated Item (which we'll force unwrap, so
    // be sure you check representsExistingItem first (!)
    var associatedItem: Item {
        Item.object(id: id!, context: persistentStore.context)!
    }
}*/
// this gives me a way to collect all the data for an Item that i might want to edit
// (or even just display).  it defaults to having values appropriate for a new item upon
// creation, and can be initialized from a Item.  this is something
// i can then hand off to an edit view.  at some point, that edit view will
// want to update an Item with this data, so see the class function
// Item.update(using editableData: EditableItemData)

// this copies all the editable data from an incoming Item.  this looks fairly
// benign, but its in the lines below that crashes did/could occur in earlier versions
// because of the main, underlying problem: if an item is deleted somewhere outside
// a view showing a list of items, the list view may wind up calling this with an item
// that's a zombie: the data behind it has been deleted, but it could still be present
// as a fault in Core Data.  i still don't quite get this -- it's something to do
// with how SwiftUI updates views and its interaction with a @FetchRequest.  this is the
// one, remaining issue with SwiftUI i hope to understand real soon.
