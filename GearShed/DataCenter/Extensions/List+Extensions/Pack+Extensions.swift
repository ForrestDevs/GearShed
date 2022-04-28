//
//  Pack+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension Pack {
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            items.forEach({ $0.objectWillChange.send() })
            gearlist.objectWillChange.send()
            packingBools.forEach({ $0.objectWillChange.send() })
        }
    }
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    var packingBools: [PackingBool] {
        if let packingBools = packingBools_ as? Set<PackingBool> {
            return packingBools.sorted(by: { $0.item.name < $1.item.name })
        }
        return []
    }
    var gearlist: Gearlist {
        get { gearlist_! }
        set {
            gearlist_?.objectWillChange.send()
            gearlist_ = newValue
            gearlist_?.objectWillChange.send()
        }
    }
}
