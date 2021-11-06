//
//  PackingBool+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import Foundation

extension PackingBool {
    
    // whether the item is a packed or not.  this fronts a Core Data boolean
    var isPacked: Bool { isPacked_ }

    // an item's associated shed.  this fronts a Core Data optional attribute.
    // if you change an item's shed, the old and the new Shed may want to
    // know that some of their computed properties could be invalidated
    var item: Item {
        get { item_! }
        set {
            item_?.objectWillChange.send()
            item_ = newValue
            item_?.objectWillChange.send()
        }
    }
    
    
}
