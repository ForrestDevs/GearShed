//
//  EditableItemData-InList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation

struct EditableItemDataInList {
    
    let persistentStore: PersistentStore
    
    var id: UUID?
    var name: String
    var gearlist: Gearlist
    
    var pile: Pile?
    var previousPile: Pile?
    
    var container: Pack?
    var previousPack: Pack?
    
    var packingBool: PackingBool?
    
    /// If the item has an ID then the item has already been created and exists in CoreData Store.
    var representsExistingItem: Bool { id != nil }
    
    /// The associated Item with the ID and in the context. Only call on Existing Items only.
    var associatedItem: Item { Item.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableItemDataInList {
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.id = item.id
        self.name = item.name
        self.gearlist = gearlist
        
        self.pile = item.gearlistPile(gearlist: gearlist)
        self.previousPile = item.gearlistPile(gearlist: gearlist)
        
        self.container = item.gearlistPack(gearlist: gearlist)
        self.previousPack = item.gearlistPack(gearlist: gearlist)
        
        self.packingBool = item.gearlistpackingBool(gearlist: gearlist)
    }
    
    
}
