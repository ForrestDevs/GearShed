//
//  EditablePileData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//  Copyright © 2022 All rights reserved.
//

import Foundation

struct EditablePileData {
    let persistentStore: PersistentStore
    var id: UUID?
    var name: String
    // to do a save/commit of an Item, it must have a non-empty name
    var canPileBeSaved: Bool { name.count > 0 }
    // useful to know if this is associated with an existing Brand
    var representsExistingPile: Bool { id != nil }
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedPile: Pile { Pile.object(id: id!, context: persistentStore.context)! }
}

extension EditablePileData {
    /// Initializer for loading a Pile that already exists.
    init(persistentStore: PersistentStore, pile: Pile) {
        self.persistentStore = persistentStore
        id = pile.id
        name = pile.name
    }
    /// Initializer for loading a new Pile that doesnt yet exist.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        name = "" 
    }
}
