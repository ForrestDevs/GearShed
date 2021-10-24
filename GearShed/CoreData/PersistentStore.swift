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
    
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// The UserDefaults suite where we're saving user data.
    let defaults: UserDefaults

    /// Loads and saves whether our premium unlock has been purchased
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        container = NSPersistentCloudKitContainer(name: "GearShed")
        
        let groupID = "group.com.yourcompany.gearshed"

        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
            container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("GearShed.sqlite")
        }
        
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores {_, error in
            
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            // also suggested for cloud-based Core Data are the two lines below for syncing with the cloud.
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
}


// MARK: - Old Persistant Store Init

// this makes sure we're the only one who can create one of these
//private init() { }

/// The lone CloudKit container used to store all our data.
/*lazy var container: NSPersistentCloudKitContainer = {
    
    let defaults = UserDefaults.standard
    let container = NSPersistentCloudKitContainer(name: "GearShed")
    
    let groupID = "group.com.yourcompany.gearshed"

    if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
        container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("GearShed.sqlite")
    }
    
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
    
    // also suggested for cloud-based Core Data are the two lines below for syncing with the cloud.
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return container
    
}()*/

