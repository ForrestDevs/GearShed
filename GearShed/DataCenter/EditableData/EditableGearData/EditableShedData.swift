//
//  EditableShedData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-03.
//

import Foundation
import SwiftUI

struct EditableShedData {
    
    let persistentStore: PersistentStore
    
    // the id of the Shed, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var id: UUID? = nil
    
    // all of the values here provide suitable defaults for a new Shed
    var name: String 
    
    // to do a save/commit of an Item, it must have a non-empty name
    var canShedBeSaved: Bool { name.count > 0 }
    
    // useful to know if this is associated with an existing Shed
    var representsExistingShed: Bool { id != nil }
    
    // useful to know the associated shed (which we'll force unwrap, so
    // be sure you check representsExistingShed first (!)
    var associatedShed: Shed { Shed.object(id: id!, context: persistentStore.context)! }
}

extension EditableShedData {
    /// Initializer for loading an existing Shed.
    init(persistentStore: PersistentStore, shed: Shed) {
        self.persistentStore = persistentStore
        self.id = shed.id
        self.name = shed.name
    }
    
    /// Initializer for loading a new Shed.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
    
}


