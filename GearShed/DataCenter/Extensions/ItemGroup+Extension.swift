//
//  ItemGroup+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import Foundation
import CoreData

extension ItemGroup: Comparable {
    
    public static func < (lhs: ItemGroup, rhs: ItemGroup) -> Bool {
        lhs.name < rhs.name
    }
    
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            sheds.forEach({ $0.objectWillChange.send() })
        }
    }
    
    var sheds: [Shed] {
        if let sheds = sheds_ as? Set<Shed> {
            return sheds.sorted(by: {$0.name < $1.name})
        }
        return []
    }
    
    
    
    
}
