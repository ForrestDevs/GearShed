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
	
	class func count() -> Int {
		return count(context: PersistentStore.shared.context)
	}

	// return a list of all sheds, optionally returning only user-defined shed
	// (i.e., excluding the unknown shed)
	class func allSheds(userShedsOnly: Bool) -> [Shed] {
		var allSheds = allObjects(context: PersistentStore.shared.context) as! [Shed]
		if userShedsOnly {
			if let index = allSheds.firstIndex(where: { $0.isUnknownShed }) {
                allSheds.remove(at: index)
			}
		}
		return allSheds
	}

	// creates a new Shed having an id, but then it's the user's responsibility
	// to fill in the field values (and eventually save)
	class func addNewShed() -> Shed {
		let newShed = Shed(context: PersistentStore.shared.context)
		newShed.id = UUID()
		return newShed
	}
	
	// parameters for the Unknown Shed.  call this only upon startup if
	// the Core Data database has not yet been initialized
	class func createUnknownShed() {
		let unknownShed = addNewShed()
		unknownShed.name_ = kUnknownShedName
        PersistentStore.shared.saveContext()
        //return unknownShed
	}
    
    class func theUnknownShed() -> Shed {
        
        let fetchRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name_ == %@", kUnknownShedName)
        
        do {
            let shed = try PersistentStore.shared.context.fetch(fetchRequest)
            return shed[0]
        } catch let error as NSError {
            fatalError("Error fetching unknown shed: //\(error.localizedDescription), \(error.userInfo)")
        }
    }
	
	class func delete(_ shed: Shed) {
		// you cannot delete the unknownShed
		guard shed.name_ != kUnknownShedName else { return }

		// retrieve the context of this Shed and get a list of
		// all items for this shed so we can work with them
		let context = shed.managedObjectContext
		let itemsAtThisShed = shed.items
		
		// reset shed associated with each of these to the unknownShed
		// (which in turn, removes the current association with shed). additionally,
		// this could affect each item's computed properties
        let theUnknownShed = Shed.theUnknownShed()
        itemsAtThisShed.forEach({ $0.shed = theUnknownShed })
		// now finish the deletion and save
		context?.delete(shed)
		try? context?.save()
	}
	
	class func updateData(using editableData: EditableItemData) {
		// if the incoming shed is not nil, then this is just a straight update.
		// otherwise, we must create the new Shed here and add it
		if let id = editableData.idShed,
			 let shed = Shed.object(id: id, context: PersistentStore.shared.context) {
			shed.updateValues(from: editableData)
		} else {
			let newShed = Shed.addNewShed()
			newShed.updateValues(from: editableData)
		}		
	}
	
	class func object(withID id: UUID) -> Shed? {
		return object(id: id, context: PersistentStore.shared.context) as Shed?
	}

	
	// MARK: - Object Methods
	
	func updateValues(from editableData: EditableItemData) {
		
		// we first make these changes directly in Core Data
		name_ = editableData.shedName
		// one more thing: items associated with this shed may want to know about
		// (some of) these changes.  reason: items rely on knowing some computed
		// properties such as uiColor, shedName, and visitationOrder.
		// usually, what i would do is this, to be sure that anyone who is
		// observing an Item as an @ObservedObject knows about the Shed update:
		items.forEach({ $0.objectWillChange.send() })
	}
	
} // end of extension Shed
