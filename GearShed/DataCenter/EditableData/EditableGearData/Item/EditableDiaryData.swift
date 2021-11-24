//
//  EditableDiaryData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation

struct EditableDiaryData {
    
    let persistentStore: PersistentStore
    
    var id: UUID?
    var name: String
    var details: String

    var item: Item?
    var gearlist: Gearlist
    
    var canBeSaved: Bool { item != nil && details.count > 0 }
    
    var representsExisting: Bool { id != nil }
    
    var associatedDiary: ItemDiary { ItemDiary.object(id: id!, context: persistentStore.context)! }
    
}

extension EditableDiaryData {
    /// Initializer for loading current ItemDiary details for Modify ItemDiary View.
    init(persistentStore: PersistentStore, diary: ItemDiary) {
        self.persistentStore = persistentStore
        self.id = diary.id
        self.gearlist = diary.gearlist
        self.item = diary.item
        self.name = diary.name
        self.details = diary.details
    }
    
    /// Initializer for standard add Diary
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        self.item = nil
        self.name = ""
        self.details = ""
    }
}
