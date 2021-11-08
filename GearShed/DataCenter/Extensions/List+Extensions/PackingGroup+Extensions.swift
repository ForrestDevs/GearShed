//
//  PackingGroup+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import Foundation

extension PackingGroup {
    
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            items.forEach({ $0.objectWillChange.send() })
        }
    }
    
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var packingBools: [PackingBool] {
        if let packingBools = packingBools_ as? Set<PackingBool> {
            return packingBools.sorted(by: { $0.item.name < $1.item.name })
        }
        return []
    }
    
    // an item's associated shed.  this fronts a Core Data optional attribute.
    // if you change an item's shed, the old and the new Shed may want to
    // know that some of their computed properties could be invalidated
    var gearlist: Gearlist {
        get { gearlist_! }
        set {
            gearlist_?.objectWillChange.send()
            gearlist_ = newValue
            gearlist_?.objectWillChange.send()
        }
    }
    
    var listGroups: [ListGroup] {
        if let listGroups = listGroups_ as? Set<ListGroup> {
            return listGroups.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    
    func packingListGroup(listGroup: ListGroup) -> ListGroup {
        let listGroup = listGroups.first(where: { $0 == listGroup })
        return listGroup!
    }
    
}
