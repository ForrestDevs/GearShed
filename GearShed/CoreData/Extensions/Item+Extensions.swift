//
//  Item+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
	// MARK: - Computed Properties
	
	// the name.  this fronts a Core Data optional attribute
	var name: String {
		get { name_ ?? "Not Available" }
		set { name_ = newValue }
	}
    
    // the details.  this fronts a Core Data optional attribute
    var detail: String {
        get { detail_ ?? "Not Available" }
        set { detail_ = newValue }
    }
	
	// whether the item is a favourtie or not.  this fronts a Core Data boolean
	var isFavourite: Bool { isFavourite_ }
    
    // whether the item is a regret or not.  this fronts a Core Data boolean
    var isRegret: Bool { isRegret_ }
	
	// whether the item is on the list or wishlist.  this fronts a Core Data boolean,
	// but when changed from true to false, it signals a purchase, so update
	// the lastDatePurchased
	var wishlist: Bool { 
		get { wishlist_ }
		set {
            wishlist_ = newValue
			if !wishlist_ { // just moved off wishlist, so record date Purchased
				datePurchased_ = Date()
			}
		}
	}
	
	// quantity of the item.   this fronts a Core Data optional attribute
	// but we need to do an Int <--> Int32 conversion
	var quantity: Int {
		get { Int(quantity_) }
		set { quantity_ = Int32(newValue) }
	}
    
    // the price.  this fronts a Core Data optional attribute
    var weight: String {
        get { weight_ ?? "" }
        set { weight_ = newValue }
    }
    
    // the price.  this fronts a Core Data optional attribute
    var price: String {
        get { price_ ?? "" }
        set { price_ = newValue }
    }
	
	// an item's associated shed.  this fronts a Core Data optional attribute.
	// if you change an item's shed, the old and the new Shed may want to
	// know that some of their computed properties could be invalidated
	var shed: Shed {
		get { shed_! }
		set {
            shed_?.objectWillChange.send()
            shed_ = newValue
            shed_?.objectWillChange.send()
		}
	}
    
    // an item's associated brand.  this fronts a Core Data optional attribute.
    // if you change an item's brand, the old and the new Brand may want to
    // know that some of their computed properties could be invalidated
    var brand: Brand {
        get { brand_! }
        set {
            brand_?.objectWillChange.send()
            brand_ = newValue
            brand_?.objectWillChange.send()
        }
    }
    
    // the date purchased
    
    var datePurchased: Date { datePurchased_ ?? Date() }
    
    // gearlists: fronts Core Data attribute gearlists_ that is an NSSet, and turns it into
    // a Swift array
    var gearlists: [Gearlist] {
        if let gearlists = gearlists_ as? Set<Gearlist> {
            return gearlists.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    
    // tripCount: computed property from Core Data trips_
    var gearlistCount: Int { gearlists_?.count ?? 0 }
    
	// the name of its associated shed
	var shedName: String { shed_?.name_ ?? "Not Available" }
    
    // the name of its associated brand
    var brandName: String { brand_?.name_ ?? "Not Available" }
	
	// MARK: - Useful Fetch Requests
	
    /*class func allItemsFR(at shed: Shed, onList: Bool = false) -> NSFetchRequest<Item> {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
        let p1 = NSPredicate(format: "shed_ == %@", shed)
        let p2 = NSPredicate(format: "wishlist_ == %d", onList)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
		request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
		request.predicate = predicate
		return request
	}
    
    class func allItemsFR(at brand: Brand) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "brand_ == %@", brand)
        return request
    }
    
    static func allItemsFR(at gearlist: Gearlist) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "gearlists_ == %@", gearlist)
        return request
    }
	
	class func allItemsFR(onList: Bool) -> NSFetchRequest<Item> {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		request.predicate = NSPredicate(format: "wishlist_ == %d", onList)
		request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
		return request
	}*/

	// MARK: - Class functions for CRUD operations
	
	// this whole bunch of static functions lets me do a simple fetch and
	// CRUD operations.
	
	class func count() -> Int {
		return count(context: PersistentStore.shared.context)
	}

	class func allItems() -> [Item] {
		return allObjects(context: PersistentStore.shared.context) as! [Item]
	}
	
	class func object(withID id: UUID) -> Item? {
		return object(id: id, context: PersistentStore.shared.context) as Item?
	}
	
	// addNewItem is the user-facing add of a new entity.  since these are
	// Identifiable objects, this makes sure we give the entity a unique id, then
	// hand it back so the user can fill in what's important to them.
	class func addNewItem() -> Item {
        let context = PersistentStore.shared.context
        let newItem = Item(context: context)
        newItem.id = UUID()
        return newItem
	}
	
	// updates data for an Item that the user has directed from an Add or Modify View.
	// if the incoming data is not associated with an item, we need to create it first
	class func updateData(using editableData: EditableItemData) {
		// if we can find an Item with the right id, use it, else create one
		if let id = editableData.id,
        let item = Item.object(id: id, context: PersistentStore.shared.context) {
			item.updateValues(from: editableData)
		} else {
			let newItem = Item.addNewItem()
			newItem.updateValues(from: editableData)
		}
	}

	class func delete(_ item: Item) {
		// remove the reference to this item from its associated shed
		// by resetting its (real, Core Data) shed to nil
		item.shed_ = nil
        item.brand_ = nil
		// now delete and save
		let context = item.managedObjectContext
		context?.delete(item)
		try? context?.save()
	}
	
	class func moveAllItemsOffWishlist() {
		for item in allItems() where item.wishlist {
			item.wishlist_ = false
		}
	}
	
	// MARK: - Object Methods
	
	// toggles the availability flag for an item
	func toggleFavouriteStatus() {
        isFavourite_ = !isFavourite_
	}
    
    // toggles the availability flag for an item
    func toggleRegretStatus() {
        isRegret_ = !isRegret_
    }

	// changes onList flag for an item
	func toggleWishlistStatus() {
		wishlist = !wishlist
	}

	func markFavourite() {
		isFavourite_ = true
	}
    
    func markRegret() {
        isRegret_ = true
    }
    
    func unmarkFavourite() {
        isFavourite_ = false
    }
    
    func unmarkRegret() {
        isRegret_ = false
    }
    
	private func updateValues(from editableData: EditableItemData) {
		name_ = editableData.name
        detail_ = editableData.details
		quantity_ = Int32(editableData.quantity)
        weight_ = editableData.weight
        price_ = editableData.price
		wishlist_ = editableData.wishlist
        isFavourite_ = editableData.isFavourite
        isRegret_ = editableData.isRegret 
		shed = editableData.shed
        brand = editableData.brand
        datePurchased_ = editableData.datePurchased
        
        gearlists.forEach({ $0.objectWillChange.send() })
        
	}
	
}

/* Discussion

update 25 December: better reorganization and removal of previous misconceptions!

(1) Fronting of Core Data Attributes

Notice that all except one of the Core Data attributes on an Item in the
CD model appear with an underscore (_) at the end of their name.
(the only exception is "id" because tweaking that name is a problem due to
conformance to Identifiable.)

my general theory of the case is that no one outside of this class (and its Core
Data based brethren, like Shed+Extensions.swift and DataController.swift) should really
be touching these attributes directly -- and certainly no SwiftUI views should
ever touch these attributes directly.

therefore, i choose to "front" each of them in this file, as well as perhaps provide
other computed properties of interest.

doing so helps smooth out the awkwardness of nil-coalescing (we don't want SwiftUI views
continually writing item.name ?? "Unknown" all over the place); and in the case of an
item's quantity, "fronting" its quantity_ attribute smooths the transition from
Int32 to Int.  indeed, in SwiftUI views, these Core Data objects should
appear just as objects, without any knowledge that they come from Core Data.

we do allow SwiftUI views to write to these fronted properties; and because we front them,
we can appropriately act on the Core Data side, sometimes performing only a simple Int --> Int32
conversion.  similarly, if we move an item off the shopping list, we can take the opportunity
then to timestamp the item as purchased.

(2) Computed Properties Based on Relationships

the situation for SwiftUI becomes more complicated when one CD object has a computed property
based on something that's not a direct attribute of the object.  examples:

    -- an Item has a `shedName` computed property = the name of its associated Shed

    -- a Shed has an `itemCount` computed property = the count of its associated Items.

for example, if a view holds on to (is a subscriber of) an Item as an @ObservedObject, and if
we change the name of its associated Shed, the view will not see this change because it
is subscribed to changes on the Item (not the Shed).

assuming the view displays the name of the associated shed using the item's shedName,
we must have the shed tell all of its items that the shedName computed property is now
invalid and some views may need to be updated, in order to keep such a view in-sync.  thus
the shed must execute

    items.forEach({ $0.objectWillChange.send() })

the same holds true for a view that holds on to (is a subscriber of) a Shed as an @ObservedObject.
if that view displays the number of items for the shed, based on the computed property
`itemCount`, then when an Item is edited to change its shed, the item must tell both its previous
and new sheds about the change by executing objectWillChange.send() for those sheds:

    (see the computed var shed: Shed setter below)

as a result, you may see some code below (and also in Shed+Extensions.swift) where, when
a SwiftUI view writes to one of the fronted properties of the Item, we also execute
shed_?.objectWillChange.send().

(3) @ObservedObject References to Items

only the SelectableItemRowView has an @ObservedObject reference to an Item, and in development,
this view (or whatever this view was during development) had a serious problem:

    if a SwiftUI view holds an Item as an @ObservedObject and that object is deleted while the
    view is still alive, the view is then holding on to a zombie object.  (Core Data does not immediately
    save out its data to disk and update its in-memory object graph for a deletion.)  depending on how
    view code accesses that object, your program may crash.

when you front all your Core Data attributes as i do below, the problem above seems to disappear, for
the most part, but i think it's really still there.  it's possible that iOS 14.2 and later have done
something about this ...
    
anyway, it's something to think about.  in this app, if you show a list of items on the shopping list,
navigate to an item's detail view, and press "Delete this Item," the row view for the item in the shopping
list is still alive and has a dead reference to the item.  SwiftUI may try to use that; and if you had
to reference that item, you should expect that every attribute will be 0 (e.g., nil for a Date, 0 for an
Integer 32, and nil for every optional attribute).

*/

