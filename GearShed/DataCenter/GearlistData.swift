//
//  TripVM.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

final class GearlistData: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    let persistentStore: PersistentStore
    
    private let gearlistController: NSFetchedResultsController<Gearlist>
    @Published var gearlists = [Gearlist]()
    
    private let adventureController: NSFetchedResultsController<Gearlist>
    @Published var adventures = [Gearlist]()
    
    private let bucketlistController: NSFetchedResultsController<Gearlist>
    @Published var bucklists = [Gearlist]()
    
    private let activityController: NSFetchedResultsController<Gearlist>
    @Published var activities = [Gearlist]()
    
    private let activityTypeController: NSFetchedResultsController<ActivityType>
    @Published var activityTypes = [ActivityType]()
    
    private let listGroupController: NSFetchedResultsController<Pile>
    @Published var listgroups = [Pile]()
    
    private let packingGroupController: NSFetchedResultsController<Pack>
    @Published var packingGroups = [Pack]()
    
    private let truePackBoolController: NSFetchedResultsController<PackingBool>
    @Published var truePackBools = [PackingBool]()
    
    private let packingBoolsController: NSFetchedResultsController<PackingBool>
    @Published var packingBools = [PackingBool]()
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let gearlistRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        gearlistRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        gearlistController = NSFetchedResultsController(fetchRequest: gearlistRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        let adventureRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        adventureRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        adventureRequest.predicate = NSPredicate(format: "isAdventure_ == %d", true)
        
        adventureController = NSFetchedResultsController(fetchRequest: adventureRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let bucketlistRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        bucketlistRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        bucketlistRequest.predicate = NSPredicate(format: "isBucketlist_ == %d", true)
        
        bucketlistController = NSFetchedResultsController(fetchRequest: bucketlistRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let activityRequest: NSFetchRequest<Gearlist> = Gearlist.fetchRequest()
        activityRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        activityRequest.predicate = NSPredicate(format: "isAdventure_ == %d", false)

        activityController = NSFetchedResultsController(fetchRequest: activityRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let activityTypeRequest: NSFetchRequest<ActivityType> = ActivityType.fetchRequest()
        activityTypeRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]

        activityTypeController = NSFetchedResultsController(fetchRequest: activityTypeRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let listGroupRequest: NSFetchRequest<Pile> = Pile.fetchRequest()
        listGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        listGroupController = NSFetchedResultsController(fetchRequest: listGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let packingGroupRequest: NSFetchRequest<Pack> = Pack.fetchRequest()
        packingGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        packingGroupController = NSFetchedResultsController(fetchRequest: packingGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let truePackBoolRequest: NSFetchRequest<PackingBool> = PackingBool.fetchRequest()
        truePackBoolRequest.sortDescriptors = [NSSortDescriptor(key: "isPacked_", ascending: true)]
        truePackBoolRequest.predicate = NSPredicate(format: "isPacked_ == %d", true)
        
        truePackBoolController = NSFetchedResultsController(fetchRequest: truePackBoolRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let packingBoolRequest: NSFetchRequest<PackingBool> = PackingBool.fetchRequest()
        packingBoolRequest.sortDescriptors = [NSSortDescriptor(key: "isPacked_", ascending: true)]
        packingBoolsController = NSFetchedResultsController(fetchRequest: packingBoolRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        gearlistController.delegate = self
        adventureController.delegate = self
        bucketlistController.delegate = self
        activityController.delegate = self
        activityTypeController.delegate = self
        listGroupController.delegate = self
        packingGroupController.delegate = self
        truePackBoolController.delegate = self
        packingBoolsController.delegate = self
        
        
        do {
            try gearlistController.performFetch()
            gearlists = gearlistController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Gearlists")
        }
        
        do {
            try adventureController.performFetch()
            adventures = adventureController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Trips")
        }
        
        do {
            try bucketlistController.performFetch()
            bucklists = bucketlistController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Bucketlists")
        }
        
        do {
            try activityController.performFetch()
            activities = activityController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Activities")
        }
        
        do {
            try activityTypeController.performFetch()
            activityTypes = activityTypeController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Activity Types")
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
        
        do {
            try truePackBoolController.performFetch()
            truePackBools = truePackBoolController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch true Bools")
        }
        
        do {
            try packingBoolsController.performFetch()
            packingBools = packingBoolsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch true Bools")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        gearlists = gearlistController.fetchedObjects ?? []
        adventures = adventureController.fetchedObjects ?? []
        bucklists = bucketlistController.fetchedObjects ?? [] 
        activities = activityController.fetchedObjects ?? []
        activityTypes = activityTypeController.fetchedObjects ?? []
        listgroups = listGroupController.fetchedObjects ?? []
        packingGroups = packingGroupController.fetchedObjects ?? []
        truePackBools = truePackBoolController.fetchedObjects ?? []
        packingBools = packingBoolsController.fetchedObjects ?? []
    }
    
    func gearlistPacks(gearlist: Gearlist) -> [Pack] {
        let packs = packingGroups.filter( { $0.gearlist == gearlist } )
        return packs
    }
    
    func gearlistPiles(gearlist: Gearlist) -> [Pile] {
        let piles = listgroups.filter( { $0.gearlist == gearlist } )
        return piles
    }
    
    // MARK: Data CUD Operations
    
    // MARK: Gearlist Methods
    /// Function to add a new Gearlist having an ID but then pass back to be created futher
    func addNewGearlistIDOnly() -> Gearlist {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        persistentStore.saveContext()
        return newGearlist
    }
    /// Function to create a new Gearlist without any Items
    func addNewGearlist(using editableData: EditableGearlistData) -> Gearlist {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        newGearlist.name = editableData.name
        newGearlist.details = editableData.details
        newGearlist.isAdventure = editableData.isAdventure
        
        if editableData.isAdventure {
            newGearlist.location = editableData.location ?? ""
            newGearlist.country = editableData.country ?? ""
            if let startDate = editableData.startDate {
                newGearlist.startDate = startDate
            }
            if let endDate = editableData.endDate {
                newGearlist.endDate = endDate
            }
        } else {
            newGearlist.activityType = editableData.activityType!
        }
    
        persistentStore.saveContext()
        return newGearlist
    }
    /// Function to update a Gearlists values using the temp stored data.
    func updateGearlist(using editableData: EditableGearlistData) {
        let gearlist = editableData.associatedGearlist
        
        gearlist.name = editableData.name
        gearlist.details = editableData.details
        
        if editableData.isAdventure {
            gearlist.location = editableData.location!
            gearlist.country = editableData.country!
            gearlist.startDate = editableData.startDate!
            gearlist.endDate = editableData.endDate!
        }
        
        if !editableData.isAdventure {
            gearlist.activityType = editableData.activityType!
        }
        gearlist.piles.forEach({ $0.objectWillChange.send() })
        gearlist.packs.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a Gearlist
    func deleteGearlist(gearlist: Gearlist) {
        for item in gearlist.items {
            let packingBool = item.gearlistpackingBool(gearlist: gearlist)!
            persistentStore.context.delete(packingBool)
        }
        
        for diary in gearlist.diaries {
            diary.item?.objectWillChange.send()
            persistentStore.context.delete(diary)
        }
        
        for pile in gearlist.piles {
            persistentStore.context.delete(pile)
        }
        
        for container in gearlist.packs {
            persistentStore.context.delete(container)
        }
        
        persistentStore.context.delete(gearlist)
        persistentStore.saveContext()
    }
    /// Function to duplicate a gearlist(Renamed with COPY)
    func duplicateGearlist(gearlist: Gearlist) {
        let newGearlist = Gearlist(context: persistentStore.context)
        newGearlist.id = UUID()
        newGearlist.name = gearlist.name + "COPY"
        newGearlist.details = gearlist.details
        newGearlist.isAdventure = gearlist.isAdventure
        
        if gearlist.isAdventure {
            if let location = gearlist.location {
                newGearlist.location = location
            }
            if let country = gearlist.country {
                newGearlist.country = country
            }
            if let startDate = gearlist.startDate {
                newGearlist.startDate = startDate
            }
            if let endDate = gearlist.endDate {
                newGearlist.endDate = endDate
            }
        } else {
            newGearlist.activityType = gearlist.activityType!
            
        }
        for item in gearlist.items {
            newGearlist.addToItems_(item)
            createNewPackBool(gearlist: newGearlist, item: item)
        }
        persistentStore.saveContext()
    }
    
    
    func toggleBucketlist(gearlist: Gearlist) {
        gearlist.isBucketlist = !gearlist.isBucketlist
        persistentStore.saveContext()
    }
    
    func addNewActivityType(using editableData: EditableActivityTypeData) {
        let newType = ActivityType(context: persistentStore.context)
        newType.id = UUID()
        newType.name = editableData.name
        persistentStore.saveContext()
    }
    
    func updateActivityType(using editableData: EditableActivityTypeData) {
        let type = editableData.associated
        type.name = editableData.name
        persistentStore.saveContext()
    }
    
    func deleteActivityType(type: ActivityType) {
        for gearlist in type.gearlists {
            deleteGearlist(gearlist: gearlist)
        }
        persistentStore.context.delete(type)
        persistentStore.saveContext()
    }
    
    func addNewActivityType(using editableData: EditableActivityTypeData, typeOut: ((ActivityType) -> ())) {
        let newType = ActivityType(context: persistentStore.context)
        newType.id = UUID()
        newType.name = editableData.name
        persistentStore.saveContext()
        typeOut(newType)
    }
    
    // MARK: Gearlist Item Methods
    /// Function to add Items to a Gearlist and create an associated packingBool upon entry.
    func addItemsToGearlist(gearlist: Gearlist, itemArray: [Item]) {
        for item in itemArray {
            gearlist.addToItems_(item)
            createNewPackBool(gearlist: gearlist, item: item)
        }
        persistentStore.saveContext()
    }
    
    /// Function to update a Gearlists Items and create an associated packingBool upon entry.
    func updateGearlistItems(gearlist: Gearlist, addingItems: [Item], removingItems: [Item]) {
        for item in addingItems {
            gearlist.addToItems_(item)
            createNewPackBool(gearlist: gearlist, item: item)
        }
        
        for item in removingItems {
            removeItemFromGearlist(item: item, gearlist: gearlist)
        }
        persistentStore.saveContext()
    }
    
    /// Function to remove an Item from a Pile + associated clean up.
    func removeItemFromGearlist(item: Item, gearlist: Gearlist) {
        // First lets delete the items packingBool
        if let packingBool = item.gearlistpackingBool(gearlist: gearlist) {
            persistentStore.context.delete(packingBool)
        }
        // Second lets remove the item -> container relationship
        if let pack = item.gearlistPack(gearlist: gearlist) {
            item.removeFromPacks_(pack)
        }
        // Third lets remove the item from its pile
        if let pile = item.gearlistPile(gearlist: gearlist) {
            item.removeFromPiles_(pile)
        }
        
        // And finally remove the item from the gearlist
        gearlist.removeFromItems_(item)
        // Save the changes.
        persistentStore.saveContext()
    }
    /// Function to remove an Item from a Pile.
    func removeItemFromPile(item: Item, pile: Pile) {
        pile.removeFromItems_(item)
        persistentStore.saveContext()
    }
    /// Function to remove an Item from a Pack.
    func removeItemFromPack(item: Item, container: Pack) {
        item.packPackingBool(pack: container)?.isPacked = false
        item.packPackingBool(pack: container)?.pack = nil
        container.removeFromItems_(item)
        persistentStore.saveContext()
    }
    
    
    // MARK: Pile Methods
    /// Function to create a new Pile.
    func addNewPile(using editableData: EditablePileData, gearlist: Gearlist) {
        let newPile = Pile(context: persistentStore.context)
        newPile.id = UUID()
        newPile.name = editableData.name
        newPile.gearlist = gearlist
        persistentStore.saveContext()
    }
    /// Function to create a new Pile from the Item Row In Gearlist then pass it back so it can populate as the selected Pile.
    func addNewPileFromItem(using editableData: EditablePileData, gearlist: Gearlist, pileOut: ((Pile) -> ())) {
        let newPile = Pile(context: persistentStore.context)
        newPile.id = UUID()
        newPile.name = editableData.name
        newPile.gearlist = gearlist
        // Pass back the newly created Pile
        pileOut(newPile)
        // Save the newly created pile. 
        persistentStore.saveContext()
    }
    
    /// Function to update a Piles items
    func updatePileItems(addingItems: [Item], removingItems: [Item], pile: Pile) {
        for item in addingItems {
            pile.addToItems_(item)
        }
        for item in removingItems {
            pile.removeFromItems_(item)
        }
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated pile updated and remove the reference to the old one.
    func updateItemPile(newPile: Pile?, oldPile: Pile?, item: Item) {
        if let oldPile = oldPile {
            item.removeFromPiles_(oldPile)
        }
        item.addToPiles_(newPile!)
        
        persistentStore.saveContext()
    }
    
    /// Function to edit Pile values.
    func updatePile(using editableData: EditablePileData) {
        let pile = editableData.associatedPile
        pile.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to delete a Pile.
    func deletePile(pile: Pile) {
        persistentStore.context.delete(pile)
        persistentStore.saveContext()
    }
    
    // MARK: Pack Methods
    /// Function to create a new Pack.
    func addNewPack(using editableData: EditablePackData, gearlist: Gearlist) {
        let newPack = Pack(context: persistentStore.context)
        newPack.id = UUID()
        newPack.name = editableData.name
        newPack.gearlist = gearlist
        // Save the newly created Pack
        persistentStore.saveContext()
    }
    /// Function to create a new Pack from the Item Row In Gearlist then pass it back so it can populate as the selected Pack.
    func addNewPackFromItem(using editableData: EditablePackData, gearlist: Gearlist, containerOut: ((Pack) -> ())) {
        let newPack = Pack(context: persistentStore.context)
        newPack.id = UUID()
        newPack.name = editableData.name
        newPack.gearlist = gearlist
        // Pass back the newly created Pack
        containerOut(newPack)
        // Save the newly created Pack
        persistentStore.saveContext()
    }
    
    func updatePackItems(addingItems: [Item], removingItems: [Item], pack: Pack) {
        for item in addingItems {
            pack.addToItems_(item)
            item.packPackingBool(pack: pack)?.pack = pack
        }
        for item in removingItems {
            pack.removeFromItems_(item)
            item.packPackingBool(pack: pack)?.pack = nil
        }
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated Pack updated and remove the reference to the old one.
    func updateItemPack(newPack: Pack?, oldPack: Pack?, item: Item, gearlist: Gearlist) {

        if let oldPack = oldPack {
            item.removeFromPacks_(oldPack)
        }
        item.addToPacks_(newPack!)
        
        item.gearlistpackingBool(gearlist: gearlist)?.pack = newPack!
        
        persistentStore.saveContext()
    }
    /// Function to edit Pack values.
    func updatePack(using editableData: EditablePackData) {
        let container = editableData.associatedPack
        container.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to delete a Pack.
    func deletePack(container: Pack) {
        for item in container.items {
            item.packPackingBool(pack: container)?.isPacked = false
        }
        persistentStore.context.delete(container)
        persistentStore.saveContext()
    }
    
    // MARK: PackBool Methods
    /// Function to create a new packingBool for an Item in a Gearlist.
    func createNewPackBool(gearlist: Gearlist, item: Item) {
        let newPackBool = PackingBool(context: persistentStore.context)
        newPackBool.id = UUID()
        newPackBool.isPacked = false
        newPackBool.gearlist = gearlist
        newPackBool.pack = nil
        newPackBool.item = item
        persistentStore.saveContext()
    }
    /// Function to toggle the state of wether an Item is packed or not.
    func togglePackBoolState(packingBool: PackingBool) {
        if packingBool.isPacked == true {
            packingBool.isPacked = false
        } else {
            packingBool.isPacked = true
        }
        persistentStore.saveContext()
    }
    
    
    func sectionByShed(itemArray: [Item]) -> [SectionShedData] {
        var completedSectionData = [SectionShedData]()
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByShed = Dictionary(grouping: itemArray, by: { $0.shed })
        
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByShed.keys.sorted() {
            completedSectionData.append(SectionShedData(title: key.name,shed: key,items: dictionaryByShed[key]!))
        }
        return completedSectionData
    }
    
    func sectionByType(array: [Gearlist]) -> [SectionTypeData] {
        var completedSectionData = [SectionTypeData]()
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByType = Dictionary(grouping: array, by: { $0.activityType! })
        
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByType.keys.sorted() {
            completedSectionData.append(SectionTypeData(title: key.name,type: key,activites: dictionaryByType[key]!))
        }
        return completedSectionData
    }
    
    func sectionByYear(array: [Gearlist]) -> ReversedCollection<[SectionYearData]> {
        var completedSectionData = [SectionYearData]()
        
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByYear = Dictionary(grouping: array, by: { $0.startDate!.startDateYear() })
        
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByYear.keys.sorted() {
            completedSectionData.append(SectionYearData(title: String(key), year: key,adventures: dictionaryByYear[key]!))
        }
        let returnArray = completedSectionData.reversed()
        
        return returnArray
    }
    
    /// Function for returning only items that arent already in the list
    var itemsNotInList = [Item]()

    /*func getItemsNotInList(gearlist: Gearlist) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
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
        }
    }*/
        
    func gearListTruePackingBools(gearlist: Gearlist) -> [PackingBool] {
        let trueGearlistPackBools: [PackingBool] = truePackBools.filter( { $0.gearlist == gearlist } )
        return trueGearlistPackBools
    }
    
    //MARK: Total Mass Methods
    func totalGrams(array: [Item]) -> String {
        // Array for holding Item Mass value in Grams as a String
        var arrayString = [String]()
        // Go through each item and add to String Array
        for item in array {
            arrayString.append(item.weight)
        }
        // Convert String array to an array of Int
        let intArray = arrayString.map { Int($0) ?? 0 }
        // Add total value of Int array
        let total = intArray.reduce(0, +)
        // Convert total value back to String and return
        let totalString = String(total)
        return totalString
    }
    func totalCost(array: [Item]) -> String {
        var arrayString = [String]()
        for x in array {
            arrayString.append(x.price)
        }
        let intArray = arrayString.map { Int($0) ?? 0 }
        let total = intArray.reduce(0, +)
        let totalString = String(total)
        return totalString
    }
    func totalLbsOz(array: [Item]) -> (lbs: String, oz: String) {
        
        /*// Arrays for holding string values of Lbs + Oz
        var arrayStringLbs = [String]()
        var arrayStringOz = [String]()
        //Populating Lbs + Oz String arrays from Items in holding array
        for x in array {
            arrayStringLbs.append(x.itemLbs)
        }
        for y in array {
            arrayStringOz.append(y.itemOZ)
        }
        // Convert the array of strings into an array of Int, and Double
        let IntLbsArray = arrayStringLbs.map { Int($0) ?? 0 }
        let DoubleOzArray = arrayStringOz.map { Double($0) ?? 0.0 }
        // Add up the total values from the arrays
        let totalLbs = IntLbsArray.reduce(0, +)
        let totalOz = DoubleOzArray.reduce(0, +)
        // Covnert total values back into string format
        let totalLbsString = String(totalLbs)
        let totalOzString = String(format: "%.2f", totalOz)
        // Return Lbs + Oz String values
        return (totalLbsString, totalOzString)*/
        
        // Taking the intial array of items and mapping the corrosponding mass value while reducing to set a total mass value from the array
        let totalLbs = array.map { Int($0.itemLbs) ?? 0 }.reduce(0, +)
        let totalOz = array.map { Double($0.itemOZ) ?? 0.0 }.reduce(0, +)
        // Doing nessecary math to make sure every 16 ounces gets counted as a pound and then convert final totals of mass units to strings
        let totalLbsString = String(totalLbs + Int((totalOz / 16).rounded(.towardZero)))
        let totalOzString = String(format: "%.2f", totalOz - Double(Int((totalOz / 16).rounded(.towardZero)) * 16))
        return (totalLbsString, totalOzString)
    
    }
    func gearlistTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for item in gearlist.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    func gearlistTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        // Array for holding gearlist Items
        var array = [Item]()
        // Populating Item Array from gearlist Items
        for item in gearlist.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    func gearlistPackTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for container in gearlist.packs {
            for item in container.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    func gearlistPackTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        // Array for holding gearlist Items
        var array = [Item]()
        for container in gearlist.packs {
            for item in container.items {
                array.append(item)
            }
        }
        return totalLbsOz(array: array)
    }
    func gearlistPileTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for pile in gearlist.piles {
            for item in pile.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    func gearlistPileTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        var array = [Item]()
        for pile in gearlist.piles {
            for item in pile.items {
                array.append(item)
            }
        }
        return totalLbsOz(array: array)
    }
    func packTotalGrams(pack: Pack) -> String {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    func packTotalLbsOz(pack: Pack) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    func pileTotalGrams(pile: Pile) -> String {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    func pileTotalLbsOz(pile: Pile) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    
    //MARK: Counter Totals
    func gearlistPackTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for container in gearlist.packs {
            for _ in container.items {
                counter = counter + 1
            }
        }
        return counter
    }
    
    func gearlistPileTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for pile in gearlist.piles {
            for _ in pile.items {
                counter = counter + 1
            }
        }
        return counter
    }
    
    func gearlistPackingBoolTotals(gearlist: Gearlist) -> Int {
        let counter = gearListTruePackingBools(gearlist: gearlist).count
        return counter
    }
    
    //MARK: Unlimted Upgrade Paywall Verification Methods
    func verifyUnlimitedGear() -> Bool {
        let canCreate = proUser() || (self.persistentStore.count(for: Item.fetchRequest()) < 30)
        if canCreate == true {
            return true
        } else {
            return false
        }
    }
    func verifyUnlimitedGearlists() -> Bool {
        let canCreate = proUser() || (self.persistentStore.count(for: Gearlist.fetchRequest()) < 1)
        if canCreate == true {
            return true
        } else {
            return false
        }
    }
    func proUser() -> Bool {
        let canCreate = (self.persistentStore.fullVersionUnlocked)
        if canCreate == true {
            return true
        } else {
            return false
        }
    }
}

/// Function to tie the relationship between an Item and a Pack.
/*func addPackingGroupToItem(item: Item, packingGroup: Pack) {
    item.addToPackingGroups_(packingGroup)
    persistentStore.saveContext()
}*/


/// Function to create a new packingBool for an Item in a packing Group iff that bool does not yet exist.
/*func createNewPackBool(container: Pack, item: Item) {
    if item.containerPackBool(container: container, item: item) != nil {
        return
    } else {
        let newPackBool = PackingBool(context: persistentStore.context)
        newPackBool.id = UUID()
        newPackBool.isPacked = false
        newPackBool.container = container
        newPackBool.item = item
    }
    persistentStore.saveContext()
}*/

/// Function to add Items to a List Group
/*func addItemsToPile(listGroup: Pile, itemArray: [Item]) {
    for item in itemArray {
        listGroup.addToItems_(item)
    }
    persistentStore.saveContext()
}*/



/// Function to remove an Item from a Pile + associated clean up.
/*func removeItemFromList(item: Item, listGroup: Pile, packingGroup: PackingGroup?) {
    // If the item has a packingGroup remove it & if so remove the associated packingBool as well.
    if let packingGroup = packingGroup {
        item.removeFromPackingGroups_(packingGroup)
        packingGroup.removeFromItems_(item)
        if let packingBool = item.packingGroupPackingBool(packingGroup: packingGroup, item: item) {
            persistentStore.context.delete(packingBool)
        }
    }
    // Remove the Item -> Pile relationship.
    item.removeFromListgroups_(listGroup)
    // Save the changes.
    persistentStore.saveContext()
}*/
/// Function to create a new Pile.
/*func createNewPile(gearlist: Gearlist) {
    let newPile = Pile(context: persistentStore.context)
    newPile.id = UUID()
    newPile.name_ = ""
    newPile.gearlist = gearlist
    persistentStore.saveContext()
}*/

/// Function to keep an Items associated packingGroup updated and remove the reference to the old one.
/*func updateItemPackingGroup(item: Item, packingGroup: PackingGroup, previousPackingGroup: PackingGroup) {
    item.removeFromPackingGroups_(previousPackingGroup)
    item.addToPackingGroups_(packingGroup)
    persistentStore.saveContext()
}*/

/// Function to keep an Items associated packingBool updated with the current packingGroup.
/*func updatePackingBools(using editableData: EditableItemDataInList) {
    let item = editableData.associatedItem
    
    if let packingBool = item.packingGroupPackingBool(packingGroup: editableData.packingGroup!, item: item) {
        packingBool.packingGroup_ = editableData.packingGroup
    } else {
        createNewPackingBool(packingGroup: editableData.packingGroup!, item: item)
    }
    persistentStore.saveContext()
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
