//
//  ViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
    
    // the manager that lets this model save, fetch,
    // write, delete, update, etc. back to core data.
    let manager = PersistentStore.shared.context
    
    func saveItemsToTrip(items: [Item], trip: Trip) {
        for item in items {
            trip.addToItems_(item)
            print("Saved \(item.name) To Trip")
        }
    }
    
}
