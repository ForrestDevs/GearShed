//
//  Trip+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI
import CoreData


extension Trip {
    
    // MARK: - Computed properties
    
    // ** please see the associated discussion over in Item+Extensions.swift **
    
    // name: fronts Core Data attribute name_ that is optional
    // if you change an trip's name, its associated items may want to
    // know that some of their computed tripName properties have been invalidated
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
    
    // tripCount: computed property from Core Data items_
    var itemCount: Int { items_?.count ?? 0 }
    
    
    // MARK: - Useful Fetch Request
    
    // a fetch request we can use in views to get all trips, sorted by name.
    // by default, you get all trips;
    class func allTripsFR() -> NSFetchRequest<Trip> {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }

    // MARK: - Class Functions
    
    class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }

    // return a list of all trips, optionally returning only user-defined trip
    // (i.e., excluding the unknown trip)
    class func allTrips() -> [Trip] {
        let allTrips = allObjects(context: PersistentStore.shared.context) as! [Trip]
        return allTrips
    }

    // creates a new Trip having an id, but then it's the user's responsibility
    // to fill in the field values (and eventually save)
    class func addNewTrip() -> Trip {
        let newTrip = Trip(context: PersistentStore.shared.context)
        newTrip.id = UUID()
        return newTrip
    }

    class func delete(_ trip: Trip) {
        // retrieve the context of this Trip and get a list of
        // all items for this trip so we can work with them
        let context = trip.managedObjectContext
        //let itemsAtThisTrip = trip.items
        
        //itemsAtThisTrip.forEach({ $0.trip = nil})
        // now finish the deletion and save
        context?.delete(trip)
        try? context?.save()
    }
    
    class func updateData(using editableData: EditableTripData) {
        // if the incoming trip is not nil, then this is just a straight update.
        // otherwise, we must create the new Trip here and add it
        if let id = editableData.idTrip,
             let trip = Trip.object(id: id, context: PersistentStore.shared.context) {
            trip.updateValues(from: editableData)
        } else {
            let newTrip = Trip.addNewTrip()
            newTrip.updateValues(from: editableData)
        }
    }
    
    class func object(withID id: UUID) -> Trip? {
        return object(id: id, context: PersistentStore.shared.context) as Trip?
    }

    
    // MARK: - Object Methods
    
    func updateValues(from editableData: EditableTripData) {
        
        // we first make these changes directly in Core Data
        name_ = editableData.tripName
        
        // one more thing: items associated with this trip may want to know about
        // (some of) these changes.  reason: items rely on knowing some computed
        // properties such as uiColor, tripName, and order.
        // usually, what i would do is this, to be sure that anyone who is
        // observing an Item as an @ObservedObject knows about the Trip update:
        
        items.forEach({ $0.objectWillChange.send() })
    }
    
} // end of extension Trip
