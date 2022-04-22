//
//  EditablePackingGroupData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation


struct EditablePackData {
    
    let persistentStore: PersistentStore
    
    var id: UUID? = nil
    var name: String
        
    var canPackBeSaved: Bool { name.count > 0 }
    
    var representsExistingPack: Bool { id != nil }
    
    var associatedPack: Pack { Pack.object(id: id!, context: persistentStore.context)! }
    
}

extension EditablePackData {
    
    /// Initializer for loading a Pack that already exists.
    init(persistentStore: PersistentStore, container: Pack) {
        self.persistentStore = persistentStore
        self.id = container.id
        self.name = container.name
    }
    
    /// Initializer for loading a new Pack that does not yet exist.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
    
}
