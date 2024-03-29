//
//  EditableGearlistData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//  Copyright © 2022 All rights reserved.
//

import Foundation

struct EditableGearlistData {
    let persistentStore: PersistentStore
    var id: UUID?
    var name: String
    var details: String
    var activityType: ActivityType? 
    var isAdventure: Bool
    var location: String?
    var country: String?
    var startDate: Date?
    var endDate: Date?
    // to do a save/commit of an Item, it must have a non-empty name
    var canGearlistBeSaved: Bool {
        var state: Bool = false
        if isAdventure {
            if name.count > 0 && startDate != nil && endDate != nil {
                state = true
            }
        } else {
            if name.count > 0 && activityType != nil {
                state = true
            }
        }
        return state
    }
    // useful to know if this is associated with an existing Brand
    var representsExistingGearlist: Bool { id != nil }
    // useful to know the associated gearlist (which we'll force unwrap, so
    // be sure you check representsExistingTrip first (!)
    var associatedGearlist: Gearlist { Gearlist.object(id: id!, context: persistentStore.context)! }
}

extension EditableGearlistData {
    /// Initializer for loading a gearlist that already exists.
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.id = gearlist.id
        self.name = gearlist.name
        self.details = gearlist.details
        self.isAdventure = gearlist.isAdventure
        self.location = gearlist.location
        self.country = gearlist.country
        self.startDate = gearlist.startDate
        self.endDate = gearlist.endDate
    }
    /// Intializer for loading between an adventure or activity gearlist
    init(persistentStore: PersistentStore, isTrip: Bool) {
        self.persistentStore = persistentStore
        self.name = ""
        self.details = ""
        self.isAdventure = isTrip
        self.location = nil
        self.country = nil
        self.startDate = nil
        self.endDate = nil
    }
    /// Initializer for loading an activity gearlist
    init(persistentStore: PersistentStore, activityType: ActivityType) {
        self.persistentStore = persistentStore
        self.name = ""
        self.details = ""
        self.activityType = activityType
        self.isAdventure = false
    }
}
