//
//  EditableBrandData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-03.
//

import Foundation
import SwiftUI

struct EditableBrandData {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    // the id of the Brand, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var id: UUID? = nil
    // all of the values here provide suitable defaults for a new Brand
    var brandName: String = ""
    
    // this copies all the editable data from an incoming Brand
    init(brand: Brand?) {
        if let brand = brand {
            id = brand.id!
            brandName = brand.name
        }
    }

    // to do a save/commit of an Item, it must have a non-empty name
    var canBrandBeSaved: Bool { brandName.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingBrand: Bool { id != nil /*&& Brand.object(withID: id!) != nil*/}
    // useful to know the associated brand (which we'll force unwrap, so
    // be sure you check representsExistingBrand first (!)
    var associatedBrand: Brand {
        Brand.object(id: id!, context: persistentStore.context)!
        //Brand.object(withID: id!)!
    }
}

