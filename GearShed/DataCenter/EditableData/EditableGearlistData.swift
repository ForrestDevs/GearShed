//
//  EditableGearlistData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import Foundation
import SwiftUI

struct EditableGearlistData {
    
    // the id of the Trip, if any, associated with this data collection
    // (nil if data for a new trip that does not yet exist)
    var idGearlist: UUID? = nil
    // all of the values here provide suitable defaults for a new Trip
    var gearlistName: String = ""
        
    // this copies all the editable data from an incoming Trip
    init(gearlist: Gearlist?) {
        if let gearlist = gearlist {
            idGearlist = gearlist.id!
            gearlistName = gearlist.name
        }
    }

    // to do a save/commit of an Item, it must have a non-empty name
    var canGearlistBeSaved: Bool { gearlistName.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingGearlist: Bool { idGearlist != nil && Gearlist.object(withID: idGearlist!) != nil }
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedGearlist: Gearlist { Gearlist.object(withID: idGearlist!)! }
    
}
