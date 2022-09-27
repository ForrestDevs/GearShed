//
//  ConsumableGear+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-09-27.
//

import Foundation
import CoreData


extension ConsumableGear {
    // an Consumable Gear list's associated Gear List. This fronts a Core Data optional attribute.
    var gearlist: Gearlist {
        get { gearlist_! }
        set { gearlist_?.objectWillChange.send()
              gearlist_ = newValue
              gearlist_?.objectWillChange.send()
        }
    }
    // an Consumable Gear list's associated items. This fronts a Core Data optional attribute.
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
}
