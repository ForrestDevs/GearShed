//
//  Gearlist+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI
import CoreData

extension Gearlist {
    // MARK: - Computed properties
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            piles.forEach({ $0.objectWillChange.send() })
            packs.forEach({ $0.objectWillChange.send() })
            items.forEach({ $0.objectWillChange.send() })
            diaries.forEach({ $0.objectWillChange.send() })
            packingBools.forEach({ $0.objectWillChange.send() })
        }
    }
    var isAdventure: Bool {
        get { isAdventure_ }
        set { isAdventure_ = newValue }
    }
    var isBucketlist: Bool {
        get { isBucketlist_ }
        set { isBucketlist_ = newValue }
    }
    var startDate: Date? {
        get { startDate_ ?? nil }
        set { startDate_ = newValue }
    }
    var diaries: [ItemDiary] {
        if let diaries = diaries_ as? Set<ItemDiary> {
            return diaries.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    var endDate: Date? {
        get { endDate_ ?? nil }
        set { endDate_ = newValue }
    }
    var location: String? {
        get { location_ ?? nil }
        set { location_ = newValue}
    }
    var country: String? {
        get { country_ ?? nil }
        set { country_ = newValue}
    }
    var details: String {
        get { details_ ?? "Unknown Detials" }
        set {
            details_ = newValue
            piles.forEach({ $0.objectWillChange.send() })
        }
    }
    // an gearlist's associated on body gear category.  this fronts a Core Data optional attribute.
    var onbodygear: OnBodyGear {
        get { onbodygear_! }
        set { onbodygear_?.objectWillChange.send()
              onbodygear_ = newValue
              onbodygear_?.objectWillChange.send()
        }
    }
    // an gearlist's associated base weight gear category.  this fronts a Core Data optional attribute.
    var baseweightgear: BaseWeightGear {
        get { baseweightgear_! }
        set { baseweightgear_?.objectWillChange.send()
              baseweightgear_ = newValue
              baseweightgear_?.objectWillChange.send()
        }
    }
    // an gearlist's associated consumable gear category.  this fronts a Core Data optional attribute.
    var consumablegear: ConsumableGear {
        get { consumablegear_! }
        set { consumablegear_?.objectWillChange.send()
              consumablegear_ = newValue
              consumablegear_?.objectWillChange.send()
        }
    }
    var piles: [Pile] {
        if let piles = piles_ as? Set<Pile> {
            return piles.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    var activityType: ActivityType? {
        get { activityType_ ?? nil }
        set { activityType_ = newValue } 
    }
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    var packs: [Pack] {
        if let packs = packs_ as? Set<Pack> {
            return packs.sorted(by: { $0.name < $1.name })
        }
        return [] 
    }
    var packingBools: [PackingBool] {
        if let packingBools = packingBools_ as? Set<PackingBool> {
            return packingBools.sorted(by: { $0.id < $1.id })
        }
        return []
    }
    // itemCount: computed property from Core Data items_
    var pileCount: Int { piles_?.count ?? 0 }
}

