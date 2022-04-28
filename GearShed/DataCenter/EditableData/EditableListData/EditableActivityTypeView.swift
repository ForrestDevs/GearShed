//
//  EditableActivityTypeView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-18.
//  Copyright © 2022 All rights reserved.
//
 
import Foundation
import SwiftUI

struct EditableActivityTypeData {
    let persistentStore: PersistentStore
    var id: UUID? = nil
    var name: String
    var canBeSaved: Bool { name.count > 0 }
    var representsExisting: Bool { id != nil }
    var associated: ActivityType { ActivityType.object(id: id!, context: persistentStore.context)! }
}

extension EditableActivityTypeData {
    /// Initializer for loading an existing Type.
    init(persistentStore: PersistentStore, activityType: ActivityType) {
        self.persistentStore = persistentStore
        self.id = activityType.id
        self.name = activityType.name
    }
    /// Initializer for loading a new Type.
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        self.name = ""
    }
}


