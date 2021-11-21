//
//  ItemImage+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation

extension ItemImage {
    
    var img: Data {
        get { img_! }
        set { img_ = newValue }
    }
    
    var item: Item {
        get { item_! }
        set { item_ = newValue } 
    }
    
}
