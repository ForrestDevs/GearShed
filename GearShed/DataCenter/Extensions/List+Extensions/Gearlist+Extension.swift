//
//  Gearlist+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import SwiftUI
import CoreData

extension Gearlist {
    
    // MARK: - Computed properties
    
    // ** please see the associated discussion over in Item+Extensions.swift **
    
    // name: fronts Core Data attribute name_ that is optional
    // if you change an trip's name, its associated items may want to
    // know that some of their computed tripName properties have been invalidated
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            clusters.forEach({ $0.objectWillChange.send() })
        }
    }
    
    var isTrip: Bool {
        get { isTrip_ }
        set { isTrip_ = newValue }
    }
    
    var startDate: Date {
        get { startDate_ ?? Date() }
        set { startDate_ = newValue }
    }
    
    var endDate: Date {
        get { endDate_ ?? Date() }
        set { endDate_ = newValue }
    }
    
    var location: String {
        get { location_ ?? "" }
        set { location_ = newValue}
    }
    
    var details: String {
        get { details_ ?? "Unknown Detials" }
        set {
            details_ = newValue
            clusters.forEach({ $0.objectWillChange.send() })
        }
    }
    
    var clusters: [Cluster] {
        if let clusters = clusters_ as? Set<Cluster> {
            return clusters.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    
    var activityType: ActivityType {
        get { activityType_! }
        set { activityType_ = newValue } 
    }
    
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name } )
        }
        return []
    }
    
    var containers: [Container] {
        if let containers = containers_ as? Set<Container> {
            return containers.sorted(by: { $0.name < $1.name })
        }
        return [] 
    }
    
    // trips: fronts Core Data attribute trips_ that is an NSSet, and turns it into
    // a Swift array
    /*var trips: [Trip] {
        if let trips = trips_ as? Set<Trip> {
            return trips.sorted(by: { $0.name < $1.name })
        }
        return []
    }*/
    
    // itemCount: computed property from Core Data items_
    var clustersCount: Int { clusters_?.count ?? 0 }
    
    // tripCount: computed property from Core Data trips_
   // var tripCount: Int { trips_?.count ?? 0 }
    
    /*class func object(withID id: UUID) -> Gearlist? {
        return object(id: id, context: PersistentStore.shared.context) as Gearlist?
    }*/
    
    
    // MARK: - Useful Fetch Request
    
    // a fetch request we can use in views to get all trips, sorted by name.
    // by default, you get all trips;
    /*class func allGearlistsFR() -> NSFetchRequest<Gearlist> {
        let request: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }*/

    // MARK: - Class Functions
    
    /*class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }*/

    // return a list of all trips, optionally returning only user-defined trip
    // (i.e., excluding the unknown trip)
    /*class func allGearlists() -> [Gearlist] {
        let allGearlists = allObjects(context: PersistentStore.shared.context) as! [Gearlist]
        return allGearlists
    }*/

    // creates a new Trip having an id, but then it's the user's responsibility
    // to fill in the field values (and eventually save)
    /*class func addNewGearlist() -> Gearlist {
        let newGearlist = Gearlist(context: PersistentStore.shared.context)
        newGearlist.id = UUID()
        return newGearlist
    }*/

    /*class func delete(_ gearlist: Gearlist) {
        // retrieve the context of this Trip and get a list of
        // all items for this trip so we can work with them
        let context = gearlist.managedObjectContext
        //let itemsAtThisTrip = trip.items
        
        //gearlist.items.forEach({ $0.gearlist = nil})
        // now finish the deletion and save
        context?.delete(gearlist)
        try? context?.save()
    }*/
    
    /*class func newGearlist(name: String) -> Gearlist {
        let newGearlist = Gearlist.addNewGearlist()
        newGearlist.name_ = name
        PersistentStore.shared.saveContext()
        return newGearlist
    }*/
    
    /*class func addNewGearlist(using editableData: EditableGearlistData, itemArray: [Item]) {
        let newGearlist = Gearlist.addNewGearlist()
        newGearlist.updateValues(from: editableData)
        Gearlist.addItemsToList(itemArray: itemArray, gearList: newGearlist)
        
    }*/
    
    /*class func removeItemFromList(item: Item, gearlist: Gearlist) {
        gearlist.removeFromItems_(item)
    }*/
    
    /*class func addItemsToList(itemArray: [Item], gearList: Gearlist) {
        for item in itemArray {
            gearList.addToItems_(item)
            print("Saved \(item.name) to \(gearList.name)")
        }
    }*/
    
    /*class func updateData(using editableData: EditableGearlistData) {
        // if the incoming trip is not nil, then this is just a straight update.
        // otherwise, we must create the new Trip here and add it
        if let id = editableData.idGearlist,
             let gearlist = Gearlist.object(id: id, context: PersistentStore.shared.context) {
            gearlist.updateValues(from: editableData)
        } else {
            let newGearlist = Gearlist.addNewGearlist()
            newGearlist.updateValues(from: editableData)
        }
    }*/
    
    

    
    // MARK: - Object Methods
    
    
    /*func updateName(gearlist: Gearlist, name: String) {
        
        gearlist.name_ = name
        PersistentStore.shared.saveContext()
    }*/
    
    
    /*func updateValues(from editableData: EditableGearlistData) {
        
        // we first make these changes directly in Core Data
        name_ = editableData.gearlistName
        
        // one more thing: items associated with this trip may want to know about
        // (some of) these changes.  reason: items rely on knowing some computed
        // properties such as uiColor, tripName, and order.
        // usually, what i would do is this, to be sure that anyone who is
        // observing an Item as an @ObservedObject knows about the Trip update:
        trips.forEach({ $0.objectWillChange.send() })
        items.forEach({ $0.objectWillChange.send() })
    }*/
    
} // end of extension Gearlist

