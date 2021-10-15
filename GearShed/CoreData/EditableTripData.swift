//
//  EditableTripData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-04.
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI

struct EditableTripData {
    
    // the id of the Trip, if any, associated with this data collection
    // (nil if data for a new trip that does not yet exist)
    var idTrip: UUID? = nil
    // all of the values here provide suitable defaults for a new Trip
    var tripName: String = ""
        
    // this copies all the editable data from an incoming Trip
    init(trip: Trip?) {
        if let trip = trip {
            idTrip = trip.id!
            tripName = trip.name
        }
    }

    // to do a save/commit of an Item, it must have a non-empty name
    var canTripBeSaved: Bool { tripName.count > 0 }

    // useful to know if this is associated with an existing Brand
    var representsExistingTrip: Bool { idTrip != nil && Trip.object(withID: idTrip!) != nil }
    // useful to know the associated trip (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedTrip: Trip { Trip.object(withID: idTrip!)! }
    
}
