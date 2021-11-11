//
//  EditableClusterData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import Foundation

struct EditableClusterData {
    
    let persistentStore: PersistentStore
        
    var id: UUID?
    var name: String
        
    // to do a save/commit of an Item, it must have a non-empty name
    var canClusterBeSaved: Bool { name.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingCluster: Bool { id != nil }
    
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedCluster: Cluster { Cluster.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableClusterData {
    
    /// Initializer for loading a Cluster that already exists.
    init(persistentStore: PersistentStore, cluster: Cluster) {
        self.persistentStore = persistentStore
        id = cluster.id
        name = cluster.name
    }
    
    /// Initializer for loading a new Cluster that doesnt yet exist.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        name = "" 
    }
    
}
