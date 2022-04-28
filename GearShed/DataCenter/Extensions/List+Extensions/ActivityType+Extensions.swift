//
//  ActivityType+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-18.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension ActivityType: Comparable {
    // add Comparable conformance: sort by name
    public static func < (lhs: ActivityType, rhs: ActivityType) -> Bool {
        lhs.name < rhs.name
    }
    var name: String {
        get { name_ ?? "Unknown Name" }
        set { name_ = newValue }
    }
    var gearlists: [Gearlist] {
        if let gearlists = gearlists_ as? Set<Gearlist>  {
            return gearlists.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
}


