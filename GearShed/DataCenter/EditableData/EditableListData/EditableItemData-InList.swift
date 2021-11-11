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
    
    var cluster: Cluster?
    var previousCluster: Cluster?
    
    var container: Container?
    var previousContainer: Container?
    
    var containerBool: ContainerBool?
    
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
        
        self.cluster = item.gearlistCluster(gearlist: gearlist)
        self.previousCluster = item.gearlistCluster(gearlist: gearlist)
        
        self.container = item.gearlistContainer(gearlist: gearlist)
        self.previousContainer = item.gearlistContainer(gearlist: gearlist)
        
        self.containerBool = item.gearlistContainerBool(gearlist: gearlist)
    }
    
    
}
