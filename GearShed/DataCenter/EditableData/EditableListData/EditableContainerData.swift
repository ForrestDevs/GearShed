//
//  EditablePackingGroupData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation


struct EditableContainerData {
    
    let persistentStore: PersistentStore
    
    var id: UUID? = nil
    var name: String
        
    var canContainerBeSaved: Bool { name.count > 0 }
    
    var representsExistingContainer: Bool { id != nil }
    
    var associatedContainer: Container { Container.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableContainerData {
    
    /// Initializer for loading a Container that already exists.
    init(persistentStore: PersistentStore, container: Container) {
        self.persistentStore = persistentStore
        self.id = container.id
        self.name = container.name
    }
    
    /// Initializer for loading a new Container that does not yet exist.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
    
}
