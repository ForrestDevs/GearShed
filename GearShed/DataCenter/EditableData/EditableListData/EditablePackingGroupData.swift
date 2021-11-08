//
//  EditablePackingGroupData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation


struct EditablePackingGroupData {
    
    let persistentStore: PersistentStore
    
    // the id of the Shed, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var id: UUID? = nil
    // all of the values here provide suitable defaults for a new Shed
    var name: String
    
    //var packingGroup: PackingGroup? 
    
    // to do a save/commit of an Item, it must have a non-empty name
    var canPackGroupBeSaved: Bool { name.count > 0 }
    
    // useful to know if this is associated with an existing Shed
    var representsExistingPackGroup: Bool { id != nil }
    
    // useful to know the associated shed (which we'll force unwrap, so
    // be sure you check representsExistingShed first (!)
    var associatedPackGroup: PackingGroup {
        PackingGroup.object(id: id!, context: persistentStore.context)!
    }
    
}

extension EditablePackingGroupData {
    
    // this copies all the editable data from an incoming Shed
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
    
}
