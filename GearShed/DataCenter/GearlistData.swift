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
    
    
    /// Function to update a Gearlists values using the temp stored data.
    func updateGearlist(using editableData: EditableGearlistData) {
        let gearlist = editableData.associatedGearlist
        gearlist.name = editableData.name
        gearlist.details = editableData.details
        gearlist.listGroups.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a Gearlist
    func deleteGearlist(gearlist: Gearlist) {
        persistentStore.context.delete(gearlist)
        persistentStore.saveContext()
    }
    
    /// Function to create a new ListGroup. 
    func createNewListGroup(gearlist: Gearlist) {
        let newListGroup = ListGroup(context: persistentStore.context)
        newListGroup.id = UUID()
        newListGroup.name_ = "New List Group"
        newListGroup.gearlist = gearlist
        persistentStore.saveContext()
    }
    
    func deleteListGroup(listGroup: ListGroup, gearlist: Gearlist) {
        for item in listGroup.items {
            if let _ = item.listGroupPackingGroup(gearlist: gearlist, listGroup: listGroup) {
                item.removeFromPackingGroups_(item.listGroupPackingGroup(gearlist: gearlist, listGroup: listGroup)!)
            }
            item.removeFromListgroups_(listGroup)
        }
        persistentStore.context.delete(listGroup)
        persistentStore.saveContext()
    }
    
    /// Function to edit ListGroup values.
    func updateListGroup(using editableData: EditableListGroupData, listGroup: ListGroup) {
        listGroup.name = editableData.name
        persistentStore.saveContext()
    }
    
    /// Function to add Items to a List Group
    func addItemsToListGroup(listGroup: ListGroup, itemArray: [Item]) {
        for item in itemArray {
            listGroup.addToItems_(item)
        }
        persistentStore.saveContext()
    }
    
    /// Function to remove an Item from a ListGroup + associated clean up.
    func removeItemFromList(item: Item, listGroup: ListGroup, packingGroup: PackingGroup?) {
        // If the item has a packingGroup remove it & if so remove the associated packingBool as well.
        if let packingGroup = packingGroup {
            item.removeFromPackingGroups_(packingGroup)
            packingGroup.removeFromItems_(item)
            if let packingBool = item.packingGroupPackingBool(packingGroup: packingGroup, item: item) {
                persistentStore.context.delete(packingBool)
            }
        }
        // Remove the Item -> ListGroup relationship.
        item.removeFromListgroups_(listGroup)
        // Save the changes.
        persistentStore.saveContext()
    }
    
    /// Function to create a new PackingGroup from the Item Row In List Group then pass it back so it can populate as the selected PackingGroup.
    func addNewPackingGroupFromItem(using editableData: EditablePackingGroupData, gearlist: Gearlist, packGroupOut: ((PackingGroup) -> ())) {
        let newPackingGroup = PackingGroup(context: persistentStore.context)
        newPackingGroup.id = UUID()
        newPackingGroup.name = editableData.name
        newPackingGroup.gearlist = gearlist
        
        // Pass back the newly created packing Group
        packGroupOut(newPackingGroup)
        // Save the newly created packing Group
        persistentStore.saveContext()
    }
    
    /// Function to tie the relationship between an Item and a packingGroup.
    func addPackingGroupToItem(item: Item, packingGroup: PackingGroup) {
        item.addToPackingGroups_(packingGroup)
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated packingGroup updated and remove the reference to the old one.
    func updateItemPackingGroup(using editableData: EditableItemDataInList) {
        let item = editableData.associatedItem
        
        if let oldPackingGroup = editableData.oldPackingGroup {
            item.removeFromPackingGroups_(oldPackingGroup)
        }
        
        if let packingGroup = editableData.packingGroup {
            packingGroup.addToListGroups_(editableData.listGroup!)
            item.addToPackingGroups_(packingGroup)
        }
        
        if let packingBool = item.packingGroupPackingBool(packingGroup: editableData.packingGroup!, item: item) {
            packingBool.packingGroup = editableData.packingGroup!
        } else {
            createNewPackingBool(packingGroup: editableData.packingGroup!, item: item)
        }
        
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated packingGroup updated and remove the reference to the old one.
    /*func updateItemPackingGroup(item: Item, packingGroup: PackingGroup, previousPackingGroup: PackingGroup) {
        item.removeFromPackingGroups_(previousPackingGroup)
        item.addToPackingGroups_(packingGroup)
        persistentStore.saveContext()
    }*/
    
    /// Function to create a new packingBool for an Item in a packing Group iff that bool does not yet exist.
    func createNewPackingBool(packingGroup: PackingGroup, item: Item) {
        if item.packingGroupPackingBool(packingGroup: packingGroup, item: item) != nil {
            return
        } else {
            let newPackingBool = PackingBool(context: persistentStore.context)
            newPackingBool.id = UUID()
            newPackingBool.isPacked = false
            newPackingBool.packingGroup = packingGroup
            newPackingBool.item = item
        }
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated packingBool updated with the current packingGroup.
    func updatePackingBools(using editableData: EditableItemDataInList) {
        let item = editableData.associatedItem
        
        if let packingBool = item.packingGroupPackingBool(packingGroup: editableData.packingGroup!, item: item) {
            packingBool.packingGroup_ = editableData.packingGroup
        } else {
            createNewPackingBool(packingGroup: editableData.packingGroup!, item: item)
        }
        persistentStore.saveContext()
    }
    
    func togglePackingBoolState(packingBool: PackingBool) {
        if packingBool.isPacked == true {
            packingBool.isPacked = false
        } else {
            packingBool.isPacked = true
        }
        persistentStore.saveContext()
    }
    
    
    
}

/// Function for returning only items that arent already in the list
//var itemsNotInList = [Item]()

/*func getItemsNotInList(gearlist: Gearlist) {
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
}*/
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
