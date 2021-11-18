//
//  EditableBrandData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-03.
//

import Foundation
import SwiftUI

struct EditableBrandData {
    
    let persistentStore: PersistentStore
    
    // the id of the Brand, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var id: UUID? = nil
    // all of the values here provide suitable defaults for a new Brand
    var name: String 
    
    // to do a save/commit of an Item, it must have a non-empty name
    var canBrandBeSaved: Bool { name.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingBrand: Bool { id != nil }
    // useful to know the associated brand (which we'll force unwrap, so
    // be sure you check representsExistingBrand first (!)
    var associatedBrand: Brand {
        Brand.object(id: id!, context: persistentStore.context)!
    }
}

extension EditableBrandData {
    
    /// Initializer for loading a new Brand
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
    
    /// Initializer for loading an existing Brand
    init(persistentStore: PersistentStore, brand: Brand) {
        self.persistentStore = persistentStore
        self.id = brand.id
        self.name = brand.name
    }
    
}

