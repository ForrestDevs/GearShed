//
//  ActivityType+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-18.
//

import Foundation

extension ActivityType {
    
    
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            gearlists.forEach({ $0.objectWillChange.send() })
        }
    }
    
    var gearlists: [Gearlist] {
        if let gearlists = gearlists_ as? Set<Gearlist>  {
            return gearlists.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    
}


