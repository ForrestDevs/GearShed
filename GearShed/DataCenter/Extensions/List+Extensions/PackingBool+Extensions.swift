//
//  PackingBool+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
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
    
    var packingGroup: PackingGroup {
        get { packingGroup_! }
        set {
            packingGroup_?.objectWillChange.send()
            packingGroup_ = newValue
            packingGroup_?.objectWillChange.send()
        }
    }
    
    
    
    
}
