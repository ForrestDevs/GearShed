//
//  DataController.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData

/// An environment singleton responsible for managing our Core Data stack, including handling
/// saving, counting fetch requests, and dealing with sample data.
final class PersistentStore: ObservableObject {
    
    private(set) static var shared = PersistentStore()
    
    // this makes sure we're the only one who can create one of these
    private init() { }
    
    /// The lone CloudKit container used to store all our data.
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "GearShed")
        
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // (2) also suggested for cloud-based Core Data are the two lines below for syncing with
        // the cloud.  i don't think there's any harm in adding these even for a single, on-disk
        // local store.
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
    /*
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Fatal error loading store: \(error.localizedDescription)")
                }
            }
        }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
    
    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext
        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.

    func delete( object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll () {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }*/


/*final class PersistenceController: ObservableObject {
    
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "GearShed")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
}*/
