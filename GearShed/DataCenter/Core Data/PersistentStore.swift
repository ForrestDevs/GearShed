//
//  PersistentStore.swift
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
    
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentContainer
    
    /// Extension to shorten the viewContext (Call PersistentStore.context)
    var context: NSManagedObjectContext { container.viewContext }
    
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
    
    /// Initializes a persistent store, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    /// - Parameter defaults: The UserDefaults suite where user data should be stored.
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        container = NSPersistentContainer(name: "GearShed", managedObjectModel: Self.model)
        
        // For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.app.gearshed.GearShed"

            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("GearShed.sqlite")
            }
            
            guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
                fatalError("\(#function): Failed to retrieve a persistent store description.")
            }
            persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        // Loads the persistent store + added instances for CloudKit updating
        container.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            // also suggested for cloud-based Core Data are the two lines below for syncing with the cloud.
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    /// The associated MoM
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "GearShed", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()
    
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func saveContext () {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    /// General Function for counting the returned objects of a fetch request
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func deleteAllEntities() {
        let entities = container.managedObjectModel.entities
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                print("Deleted Entitie - ", entity)
            } catch let error as NSError {
                print("Delete ERROR \(entity)")
                print(error)
            }
        }
        saveContext()
    }
    
    
    //MARK: Global User Settings
    //@Published var stateUnit: String = Prefs.shared.weightUnit
    
    /*func convertMetricToImp(grams: String) -> (lbs: String, oz: String) {
        let weight = Double(grams) ?? 0
        var totalOZ: Double {
            weight / 28.3495
        }
        var lbs: Int {
            let x = (totalOZ / 16)
            return Int(x.rounded(.towardZero))
        }
        var oz: Double {
            ( totalOZ - Double(lbs * 16) )
        }
        let StringLbs = String(lbs)
        let StringOz = String(format: "%.2f", oz)
        return (StringLbs, StringOz)
    }
    
    func convertImpToMetric(lbs: String, oz: String) -> String {
        //print("LBS as string \(lbs)")
        let IntPound = Int(lbs)
        //print("LBS as Int \(IntPound ?? 0)")
        let poundAsOunces = Double((IntPound ?? 0) * 16)
        //print(" total Ounces from pounds \(poundAsOunces) ")
        //print ("OZ as String \(oz)")
        let ozD: Double = Double(oz) ?? 0.0
        //print("Oz as Double \(ozD) ")
        var totalOZ: Double {
            poundAsOunces + ozD
        }
        //print("total Ounces \(totalOZ) ")
        var grams: Double {
            totalOZ * 28.3495
        }
        //print("grams \(grams)")
        let totalGrams = grams.rounded(.toNearestOrEven)
        //print("total grams rounded \(totalGrams)")
        let StringGram = String(format: "%.0f", totalGrams)
        //print(" string total grams \(StringGram) ")
        return StringGram
    }*/
}

