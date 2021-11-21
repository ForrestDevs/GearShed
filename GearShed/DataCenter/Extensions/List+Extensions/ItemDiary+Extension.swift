//
//  ItemDiary+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation

extension ItemDiary {
    
    var name: String {
        get { name_ ?? "Not Available" }
        set { name_ = newValue }
    }
    
    var details: String {
        get { details_ ?? "Not Available"}
        set { details_ = newValue }
    }
    
    var item: Item {
        get { item_! }
        set { item_ = newValue }
    }
    
    var gearlist: Gearlist {
        get { gearlist_! }
        set { gearlist_ = newValue }
    }
    
}
