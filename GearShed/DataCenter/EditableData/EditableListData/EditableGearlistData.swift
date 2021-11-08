//
//  EditableGearlistData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import Foundation

struct EditableGearlistData {
    
    let persistentStore: PersistentStore
        
    var id: UUID?
    var name: String
    
    var details: String
        
    // to do a save/commit of an Item, it must have a non-empty name
    var canGearlistBeSaved: Bool { name.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingGearlist: Bool { id != nil }
    
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedGearlist: Gearlist { Gearlist.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableGearlistData {
    
    /// Initializer for loading a gearlist that already exists.
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        id = gearlist.id
        name = gearlist.name
        details = gearlist.details
    }
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
        self.details = "" 
    }
    
}