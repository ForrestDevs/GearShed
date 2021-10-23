//
//  Category+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownCategoryName = "Uncategorized"

extension Category: Comparable {
	
	// add Comparable conformance: sort by name
	public static func < (lhs: Category, rhs: Category) -> Bool {
		lhs.name < rhs.name
	}
	
	// MARK: - Computed properties
	
	// ** please see the associated discussion over in Item+Extensions.swift **
	
	// name: fronts Core Data attribute name_ that is optional
	// if you change an category's name, its associated items may want to
	// know that some of their computed categoryName properties have been invalidated
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
	
	// itemCount: computed property from Core Data items_
	var itemCount: Int { items_?.count ?? 0 }
	
	// simplified test of "is the unknown category"
	var isUnknownCategory: Bool { name_ == kUnknownCategoryName }
	
    // MARK: - Class Functions
	
	class func count() -> Int {
		return count(context: PersistentStore.shared.context)
	}

	// return a list of all categories, optionally returning only user-defined category
	// (i.e., excluding the unknown category)
	class func allCategories(userCategorysOnly: Bool) -> [Category] {
		var allCategories = allObjects(context: PersistentStore.shared.context) as! [Category]
		if userCategorysOnly {
			if let index = allCategories.firstIndex(where: { $0.isUnknownCategory }) {
				allCategories.remove(at: index)
			}
		}
		return allCategories
	}

	// creates a new Category having an id, but then it's the user's responsibility
	// to fill in the field values (and eventually save)
	class func addNewCategory() -> Category {
		let newCategory = Category(context: PersistentStore.shared.context)
		newCategory.id = UUID()
		return newCategory
	}
	
	// parameters for the Unknown Category.  call this only upon startup if
	// the Core Data database has not yet been initialized
	class func createUnknownCategory() {
		let unknownCategory = addNewCategory()
		unknownCategory.name_ = kUnknownCategoryName
        PersistentStore.shared.saveContext()
        //return unknownCategory
	}
    
    class func theUnknownCategory() -> Category {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name_ == %@", kUnknownCategoryName)
        
        do {
            let category = try PersistentStore.shared.context.fetch(fetchRequest)
            return category[0]
        } catch let error as NSError {
            fatalError("Error fetching unknown category: //\(error.localizedDescription), \(error.userInfo)")
        }
    }
	
	class func delete(_ category: Category) {
		// you cannot delete the unknownCategory
		guard category.name_ != kUnknownCategoryName else { return }

		// retrieve the context of this Category and get a list of
		// all items for this category so we can work with them
		let context = category.managedObjectContext
		let itemsAtThisCategory = category.items
		
		// reset category associated with each of these to the unknownCategory
		// (which in turn, removes the current association with category). additionally,
		// this could affect each item's computed properties
        let theUnknownCategory = Category.theUnknownCategory()
        itemsAtThisCategory.forEach({ $0.category = theUnknownCategory })
		// now finish the deletion and save
		context?.delete(category)
		try? context?.save()
	}
	
	class func updateData(using editableData: EditableItemData) {
		// if the incoming category is not nil, then this is just a straight update.
		// otherwise, we must create the new Category here and add it
		if let id = editableData.idCategory,
			 let category = Category.object(id: id, context: PersistentStore.shared.context) {
			category.updateValues(from: editableData)
		} else {
			let newCategory = Category.addNewCategory()
			newCategory.updateValues(from: editableData)
		}		
	}
	
	class func object(withID id: UUID) -> Category? {
		return object(id: id, context: PersistentStore.shared.context) as Category?
	}

	
	// MARK: - Object Methods
	
	func updateValues(from editableData: EditableItemData) {
		
		// we first make these changes directly in Core Data
		name_ = editableData.categoryName
		// one more thing: items associated with this category may want to know about
		// (some of) these changes.  reason: items rely on knowing some computed
		// properties such as uiColor, categoryName, and visitationOrder.
		// usually, what i would do is this, to be sure that anyone who is
		// observing an Item as an @ObservedObject knows about the Category update:
		items.forEach({ $0.objectWillChange.send() })
	}
	
} // end of extension Category
