//
//  Category+Extensions.swift
//  ShoppingList
//
//  Created by Jerry on 5/6/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownCategoryName = "Unknown Category"
let kUnknownCategoryVisitationOrder: Int32 = INT32_MAX

extension Category: Comparable {
	
	// add Comparable conformance: sort by visitation order
	public static func < (lhs: Category, rhs: Category) -> Bool {
		lhs.visitationOrder_ < rhs.visitationOrder_
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
	
	// visitationOrder: fronts Core Data attribute visitationOrder_ that is Int32
	// if you change an category's visitationOrder, its associated items may want to
	// know that some of their computed visitationOrder property has been invalidated
	var visitationOrder: Int {
		get { Int(visitationOrder_) }
		set {
			visitationOrder_ = Int32(newValue)
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
	var isUnknownCategory: Bool { visitationOrder_ == kUnknownCategoryVisitationOrder }
	
	// this collects the four uiColor components into a single uiColor.
	// if you change a category's uiColor, its associated items will want to
	// know that their uiColor computed properties have been invalidated
	var uiColor: UIColor {
		get {
			UIColor(red: CGFloat(red_), green: CGFloat(green_), blue: CGFloat(blue_), alpha: CGFloat(opacity_))
		}
		set {
			if let components = newValue.cgColor.components {
				red_ = Double(components[0])
				green_ = Double(components[1])
				blue_ = Double(components[2])
				opacity_ = Double(components[3])
				items.forEach({ $0.objectWillChange.send() })
			}
		}
	}

	// MARK: - Useful Fetch Request
	
	// a fetch request we can use in views to get all categorys, sorted in visitation order.
	// by default, you get all categorys; setting onList = true returns only categorys that
	// have at least one of its shopping items currently on the shopping list
	class func allCategorysFR(onList: Bool = false) -> NSFetchRequest<Category> {
		let request: NSFetchRequest<Category> = Category.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
		if onList {
			request.predicate = NSPredicate(format: "ANY items_.onList_ == true")
		}
		return request
	}

	// MARK: - Class Functions
	
	class func count() -> Int {
		return count(context: PersistentStore.shared.context)
	}

	// return a list of all categorys, optionally returning only user-defined category
	// (i.e., excluding the unknown category)
	class func allCategorys(userCategorysOnly: Bool) -> [Category] {
		var allCategorys = allObjects(context: PersistentStore.shared.context) as! [Category]
		if userCategorysOnly {
			if let index = allCategorys.firstIndex(where: { $0.isUnknownCategory }) {
				allCategorys.remove(at: index)
			}
		}
		return allCategorys
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
	class func createUnknownCategory() -> Category {
		let unknownCategory = addNewCategory()
		unknownCategory.name_ = kUnknownCategoryName
		unknownCategory.red_ = 0.5
		unknownCategory.green_ = 0.5
		unknownCategory.blue_ = 0.5
		unknownCategory.opacity_ = 0.5
		unknownCategory.visitationOrder_ = kUnknownCategoryVisitationOrder
		return unknownCategory
	}

	class func unknownCategory() -> Category {
		// we only keep one "UnknownCategory" in the data store.  you can find it because its
		// visitationOrder is the largest 32-bit integer. to make the app work, however, we need this
		// default category to exist!
		//
		// so if we ever need to get the unknown category from the database, we will fetch it;
		// and if it's not there, we will create it then.
		let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "visitationOrder_ == %d", kUnknownCategoryVisitationOrder)
		do {
			let categorys = try PersistentStore.shared.context.fetch(fetchRequest)
			if categorys.count >= 1 { // there should be no more than one
				return categorys[0]
			} else {
				return createUnknownCategory()
			}
		} catch let error as NSError {
			fatalError("Error fetching unknown category: \(error.localizedDescription), \(error.userInfo)")
		}
	}
	
	class func delete(_ category: Category) {
		// you cannot delete the unknownCategory
		guard category.visitationOrder_ != kUnknownCategoryVisitationOrder else { return }

		// retrieve the context of this Category and get a list of
		// all items for this category so we can work with them
		let context = category.managedObjectContext
		let itemsAtThisCategory = category.items
		
		// reset category associated with each of these to the unknownCategory
		// (which in turn, removes the current association with category). additionally,
		// this could affect each item's computed properties
		let theUnknownCategory = Category.unknownCategory()
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
		visitationOrder_ = Int32(editableData.visitationOrder)
		if let components = editableData.color.cgColor?.components {
			red_ = Double(components[0])
			green_ = Double(components[1])
			blue_ = Double(components[2])
			opacity_ = Double(components[3])
		} else {
			red_ = 0.0
			green_ = 1.0
			blue_ = 0.0
			opacity_ = 0.5
		}
		
		// one more thing: items associated with this category may want to know about
		// (some of) these changes.  reason: items rely on knowing some computed
		// properties such as uiColor, categoryName, and visitationOrder.
		// usually, what i would do is this, to be sure that anyone who is
		// observing an Item as an @ObservedObject knows about the Category update:
		
		items.forEach({ $0.objectWillChange.send() })
	}
	
} // end of extension Category
