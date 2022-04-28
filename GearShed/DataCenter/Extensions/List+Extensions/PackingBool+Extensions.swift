//
//  PackingBool+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension PackingBool {
    // whether the item is a packed or not.  this fronts a Core Data boolean
    var isPacked: Bool {
        get { isPacked_ }
        set { isPacked_ = newValue }
    }
    var item: Item {
        get { item_! }
        set {
            item_?.objectWillChange.send()
            item_ = newValue
            item_?.objectWillChange.send()
        }
    }
    var pack: Pack? {
        get { pack_ }
        set {
            pack_?.objectWillChange.send()
            pack_ = newValue
            pack_?.objectWillChange.send()
        }
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
