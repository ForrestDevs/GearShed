//
//  Shed+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownShedName = "Uncategorized"
let kUnknownShedID: Int32 = INT32_MAX

extension Shed: Comparable {
    
	// add Comparable conformance: sort by name
	public static func < (lhs: Shed, rhs: Shed) -> Bool {
		lhs.name < rhs.name
	}
	
	// MARK: - Computed properties
	
	// ** please see the associated discussion over in Item+Extensions.swift **
	
	// name: fronts Core Data attribute name_ that is optional
	// if you change an shed's name, its associated items may want to
	// know that some of their computed shedName properties have been invalidated
	var name: String {
		get { name_ ?? "Unknown Name" }
		set {
			name_ = newValue
			items.forEach({ $0.objectWillChange.send() })
		}
	}
    
    var unShedID: Int {
        get { Int(unShedID_) }
    }
	
	// items: fronts Core Data attribute items_ that is an NSSet, and turns it into
	// a Swift array
	var items: [Item] {
		if let items = items_ as? Set<Item> {
            // returns an array of items sorted by name and filtering out any wishList Items
            return items.sorted(by: { $0.name < $1.name }).filter { !$0.wishlist }
		}
		return []
	}
    
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var regretItems: [Item] {
        if let items = items_ as? Set<Item> {
            // returns an array of items sorted by name and filtering out any wishList Items
            return items.sorted(by: { $0.name < $1.name }).filter { $0.isRegret }
        }
        return []
    }
	
	// itemCount: computed property from Core Data items_
	var itemCount: Int { items_?.count ?? 0 }
	
	// simplified test of "is the unknown shed"
	var isUnknownShed: Bool { name_ == kUnknownShedName }
	
    // MARK: - Class Functions
	
	/*class func count() -> Int {
		return count(context: PersistentStore.shared.context)
	}
    
    class func object(withID id: UUID) -> Shed? {
        return object(id: id, context: PersistentStore.shared.context) as Shed?
    }*/

	// return a list of all sheds, optionally returning only user-defined shed
	// (i.e., excluding the unknown shed)
	/*class func allSheds(userShedsOnly: Bool) -> [Shed] {
		var allSheds = allObjects(context: PersistentStore.shared.context) as! [Shed]
		if userShedsOnly {
			if let index = allSheds.firstIndex(where: { $0.isUnknownShed }) {
                allSheds.remove(at: index)
			}
		}
		return allSheds
	}*/

	// creates a new Shed having an id, but then it's the user's responsibility
	// to fill in the field values (and eventually save)
	/*class func addNewShed() -> Shed {
		let newShed = Shed(context: PersistentStore.shared.context)
		newShed.id = UUID()
		return newShed
	}*/
	
	// parameters for the Unknown Shed.  call this only upon startup if
	// the Core Data database has not yet been initialized
    /*class func createUnknownShed() -> Shed {
        let context = Shed.managedObjectContext

        let unSheded = Shed(context: context)
        unSheded.name_ = kUnknownBrandName
        unSheded.id = UUID()
        unSheded.unShedID_ = kUnknownShedID
        PersistentStore.shared.saveContext()
        
        return unSheded
    }*/
    
    
    /*class func unknownShed() -> Shed {
        // we only keep one "UnknownBrand" in the data store.  you can find it because its
        // order is the largest 32-bit integer. to make the app work, however, we need this
        // default brand to exist!
        //
        // so if we ever need to get the unknown brand from the database, we will fetch it;
        // and if it's not there, we will create it then.
        let fetchRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "unShedID_ == %d", kUnknownShedID)
        
        do {
            let shed = try PersistentStore.shared.context.fetch(fetchRequest)
            if shed.count >= 1 {
                return shed[0]
            } else {
                return createUnknownShed()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown brand: \(error.localizedDescription), \(error.userInfo)")
        }
    }*/
    
    /*class func theUnknownShed() -> Shed {
        
        let fetchRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name_ == %@", kUnknownShedName)
        
        do {
            let shed = try PersistentStore.shared.context.fetch(fetchRequest)
            return shed[0]
        } catch let error as NSError {
            fatalError("Error fetching unknown shed: //\(error.localizedDescription), \(error.userInfo)")
        }
    }*/
	
	/*class func delete(_ shed: Shed) {
		// you cannot delete the unknownShed
		guard shed.unShedID != kUnknownShedID else { return }

		// retrieve the context of this Shed and get a list of
		// all items for this shed so we can work with them
		let context = shed.managedObjectContext
		let itemsAtThisShed = shed.items
		
		// reset shed associated with each of these to the unknownShed
		// (which in turn, removes the current association with shed). additionally,
		// this could affect each item's computed properties
        let theUnknownShed = Shed.unknownShed()
        itemsAtThisShed.forEach({ $0.shed = theUnknownShed })
		// now finish the deletion and save
		context?.delete(shed)
		try? context?.save()
	}*/
	
	/*class func updateData(using editableData: EditableShedData) {
		// if the incoming shed is not nil, then this is just a straight update.
		// otherwise, we must create the new Shed here and add it
		if let id = editableData.id,
			 let shed = Shed.object(id: id, context: PersistentStore.shared.context) {
			shed.updateValues(from: editableData)
		} else {
			let newShed = Shed.addNewShed()
			newShed.updateValues(from: editableData)
		}		
	}*/
    
    /*class func addNewShedFromItem(using editableData: EditableShedData, shedOut: ( (Shed) -> () ) ) {
        let newShed = Shed.addNewShed()
        newShed.updateValues(from: editableData)
        shedOut(newShed)
    }*/
	
	

	
	// MARK: - Object Methods
    
    /*func updateName(shed: Shed, name: String) {
        
        shed.name_ = name
        PersistentStore.shared.saveContext()
    }*/
	
    /*func updateValues(from editableData: EditableShedData) {
		
		// we first make these changes directly in Core Data
		name_ = editableData.shedName
		// one more thing: items associated with this shed may want to know about
		// (some of) these changes.  reason: items rely on knowing some computed
		// properties such as uiColor, shedName, and visitationOrder.
		// usually, what i would do is this, to be sure that anyone who is
		// observing an Item as an @ObservedObject knows about the Shed update:
		items.forEach({ $0.objectWillChange.send() })
	}*/
	
} // end of extension Shed
