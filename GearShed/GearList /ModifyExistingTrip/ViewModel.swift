//
//  ViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
    
    // the manager that lets this model save, fetch,
    // write, delete, update, etc. back to core data.
    let manager = PersistentStore.shared.context
    
    func saveItemsToGearlist(items: [Item], gearlist: Gearlist) {
        for item in items {
            gearlist.addToItems_(item)
            print("Saved \(item.name) To Gearlist")
        }
    }
    
}
