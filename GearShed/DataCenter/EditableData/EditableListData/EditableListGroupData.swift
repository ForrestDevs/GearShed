//
//  EditableListGroupData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation

struct EditableListGroupData {
    
    let persistentStore: PersistentStore
        
    var id: UUID?
    var name: String
        
    // to do a save/commit of an Item, it must have a non-empty name
    var canListGroupBeSaved: Bool { name.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingListGroup: Bool { id != nil }
    
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedListGroup: ListGroup { ListGroup.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableListGroupData {
    
    /// Initializer for loading a gearlist that already exists.
    init(persistentStore: PersistentStore, listGroup: ListGroup) {
        self.persistentStore = persistentStore
        id = listGroup.id
        name = listGroup.name
    }
    
}
