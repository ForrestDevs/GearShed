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
    
    private let listGroupController: NSFetchedResultsController<ListGroup>
    @Published var listgroups = [ListGroup]()
    
    private let packingGroupController: NSFetchedResultsController<PackingGroup>
    @Published var packingGroups = [PackingGroup]()
        
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let gearlistRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        gearlistRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        gearlistController = NSFetchedResultsController(fetchRequest: gearlistRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let listGroupRequest: NSFetchRequest<ListGroup> = ListGroup.fetchRequest()
        listGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        listGroupController = NSFetchedResultsController(fetchRequest: listGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let packingGroupRequest: NSFetchRequest<PackingGroup> = PackingGroup.fetchRequest()
        packingGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        packingGroupController = NSFetchedResultsController(fetchRequest: packingGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        gearlistController.delegate = self
        listGroupController.delegate = self
        packingGroupController.delegate = self
        
        do {
            try gearlistController.performFetch()
            gearlists = gearlistController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch gearlists")
        }
        
        do {
            try listGroupController.performFetch()
            listgroups = listGroupController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch listGroups")
        }
        
        do {
            try packingGroupController.performFetch()
            packingGroups = packingGroupController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch packingGroups")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        gearlists = gearlistController.fetchedObjects ?? []
        listgroups = listGroupController.fetchedObjects ?? []
        packingGroups = packingGroupController.fetchedObjects ?? []
    }
    
    func gearlistPackingGroups(gearlist: Gearlist) -> [PackingGroup] {
        let packingGroups = packingGroups.filter( { $0.gearlist == gearlist } )
        return packingGroups
    }
    
    // MARK: Data CUD Operations
    
    /// Function to add a new Gearlist having an ID but then pass back to be created futher
    func addNewGearlistIDOnly() -> Gearlist {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        persistentStore.saveContext()
        return newGearlist
    }
    /// Function to create a new Gearlist without any Items
    func addNewGearlist(using editableData: EditableGearlistData) {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        newGearlist.name_ = editableData.name
        persistentStore.saveContext()
    }
    /// Function to create a new Gearlist with items using the temp stored data.
    /*func addNewGearlistWithItems(using editableData: EditableGearlistData, itemArray: [Item]) {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        newGearlist.name_ = editableData.gearlistName
        
        for item in itemArray {
            newGearlist.addToItems_(item)
        }
        
        persistentStore.saveContext()
    }*/
    /// Function to update a Gearlists values using the temp stored data.
    func updateGearlist(using editableData: EditableGearlistData) {
        let gearlist = editableData.associatedGearlist
        gearlist.name_ = editableData.name
        gearlist.listGroups.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a Gearlist
    func deleteGearlist(gearlist: Gearlist) {
        // remove the reference to this item from its associated shed & brand
        // by resetting its (real, Core Data) shed & brand to nil
        persistentStore.context.delete(gearlist)
        persistentStore.saveContext()
    }
    
    /// Function to create a new ItemGroup In List
    func createNewListGroup(gearlist: Gearlist) {
        let newListGroup = ListGroup(context: persistentStore.context)
        
        newListGroup.id = UUID()
        newListGroup.name_ = "New List Group"
        newListGroup.gearlist = gearlist
        
        persistentStore.saveContext()
    }
    
    /// Function to add Items to a List Group
    func addItemsToListGroup(listGroup: ListGroup, itemArray: [Item]) {
        for item in itemArray {
            listGroup.addToItems_(item)
        }
    }
    
    /// Function to create a new PackingGroup from the Item Row In List Group then pass it back so it can populate as the selected PackingGroup.
    func addNewPackingGroupFromItem(using editableData: EditablePackingGroupData, packGroupOut: ((PackingGroup) -> ())) {
        let newPackingGroup = PackingGroup(context: persistentStore.context)
        newPackingGroup.id = UUID()
        newPackingGroup.name_ = editableData.name
        persistentStore.saveContext()
        packGroupOut(newPackingGroup)
    }
    
    /// Function for returning only items that arent already in the list
    var itemsNotInList = [Item]()
    
    func getItemsNotInList(gearlist: Gearlist) {
        /*let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "wishlist_ == %d", false)
        var array1 = [Item]()
        let array2 = gearlist.items
        do {
            itemsNotInList.removeAll()
            array1 = try persistentStore.context.fetch(request)
            array1 = array1.filter { !array2.contains($0) }
            itemsNotInList = array1
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }*/
    }
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
}
