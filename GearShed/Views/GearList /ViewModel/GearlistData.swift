//
//  TripVM.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData

final class GearlistData: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    let persistentStore: PersistentStore
    
    private let gearlistController: NSFetchedResultsController<Gearlist>
    @Published var gearlists = [Gearlist]()
    
    private let tripController: NSFetchedResultsController<Trip>
    @Published var trips = [Trip]()
        
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let gearlistRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        gearlistRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        gearlistController = NSFetchedResultsController(fetchRequest: gearlistRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let tripRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        tripController = NSFetchedResultsController(fetchRequest: tripRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        gearlistController.delegate = self
        tripController.delegate = self
        
        do {
            try gearlistController.performFetch()
            gearlists = gearlistController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch gearlists")
        }
        
        do {
            try tripController.performFetch()
            trips = tripController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch trips")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        gearlists = gearlistController.fetchedObjects ?? []
        trips = tripController.fetchedObjects ?? []
    }
    
    // Function for returning only items that arent already in the list 
    var itemsNotInList = [Item]()
    
    func getItemsNotInList(gearlist: Gearlist) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "wishlist_ == %d", false)
        var array1 = [Item]()
        let array2 = gearlist.items
        do {
            itemsNotInList.removeAll()
            array1 = try PersistentStore.shared.context.fetch(request)
            array1 = array1.filter { !array2.contains($0) }
            itemsNotInList = array1
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    
    func deleteGearlist(gearlist: Gearlist) {
        //let gearlist = gearlist
        //persistentStore.delete(gearlist)
    }
    
}
