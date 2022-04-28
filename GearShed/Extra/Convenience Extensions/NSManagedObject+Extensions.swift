//
//  NSManagedObject+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
	// makes it easy to count NSManagedObjects in a given context.  useful during
	// app development.  used in Item.count() and Shed.count() in this app
	class func count(context: NSManagedObjectContext) -> Int {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		do {
			let result = try context.count(for: fetchRequest)
			return result
		} catch let error as NSError {
			NSLog("Error counting NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return 0
	}
	// simple way to get all objects
	class func allObjects(context: NSManagedObjectContext) -> [NSManagedObject] {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		do {
			let result = try context.fetch(fetchRequest)
			return result
		} catch let error as NSError {
			NSLog("Error fetching NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return []
	}
	// finds an NSManagedObject with the given UUID (there should only be one, really)
	class func object(id: UUID, context: NSManagedObjectContext) -> Self? {
		let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: Self.description())
		fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		do {
			let results = try context.fetch(fetchRequest)
			return results.first
		} catch let error as NSError {
			NSLog("Error fetching NSManagedObjects \(Self.description()): \(error.localizedDescription), \(error.userInfo)")
		}
		return nil
	}
}
