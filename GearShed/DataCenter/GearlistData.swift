//
//  GearlistData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
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
            print("Failed to fetch Adventures")
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
            print("Failed to fetch Piles")
        }
        do {
            try packingGroupController.performFetch()
            packingGroups = packingGroupController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Packs")
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
        newGearlist.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        newGearlist.details = editableData.details.trimmingCharacters(in: .whitespacesAndNewlines)
        newGearlist.isAdventure = editableData.isAdventure
        
        if editableData.isAdventure {
            newGearlist.location = editableData.location?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            newGearlist.country = editableData.country?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
        gearlist.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        gearlist.details = editableData.details.trimmingCharacters(in: .whitespacesAndNewlines)
        if editableData.isAdventure {
            gearlist.location = editableData.location?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            gearlist.country = editableData.country?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            gearlist.startDate = editableData.startDate!
            gearlist.endDate = editableData.endDate!
        }
        if !editableData.isAdventure {
            gearlist.activityType = editableData.activityType!
        }
        gearlist.items.forEach({ $0.objectWillChange.send() })
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
        for pack in gearlist.packs {
            persistentStore.context.delete(pack)
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
    /// Function to toggle the bucketlist status of an Adventure
    func toggleBucketlist(gearlist: Gearlist) {
        gearlist.isBucketlist = !gearlist.isBucketlist
        persistentStore.saveContext()
    }
    /// Function to add a new Activity Type
    func addNewActivityType(using editableData: EditableActivityTypeData) {
        let newType = ActivityType(context: persistentStore.context)
        newType.id = UUID()
        newType.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to edit the name of an Activity Type
    func updateActivityType(using editableData: EditableActivityTypeData) {
        let type = editableData.associated
        type.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to delete an activity type (WARNING Will Delete all activities asociated with the activity type)
    func deleteActivityType(type: ActivityType) {
        for gearlist in type.gearlists {
            deleteGearlist(gearlist: gearlist)
        }
        persistentStore.context.delete(type)
        persistentStore.saveContext()
    }
    /// Function to add a new activity type and pass it back to be used in the add activity screen
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
    /// Function to remove an Item from a Gearlist + associated clean up.
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
        pile.objectWillChange.send()
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
        newPile.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        newPile.gearlist = gearlist
        persistentStore.saveContext()
    }
    /// Function to create a new Pile from the Item Row In Gearlist then pass it back so it can populate as the selected Pile.
    func addNewPileFromItem(using editableData: EditablePileData, gearlist: Gearlist, pileOut: ((Pile) -> ())) {
        let newPile = Pile(context: persistentStore.context)
        newPile.id = UUID()
        newPile.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
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
        pile.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        persistentStore.saveContext()
    }
    /// Function to delete a Pile.
    func deletePile(pile: Pile) {
        persistentStore.context.delete(pile)
        persistentStore.saveContext()
    }
    /// Function to return the Piles of a specific gearlist
    func gearlistPiles(gearlist: Gearlist) -> [Pile] {
        let piles = listgroups.filter( { $0.gearlist == gearlist } )
        return piles
    }
    // MARK: Pack Methods
    /// Function to create a new Pack.
    func addNewPack(using editableData: EditablePackData, gearlist: Gearlist) {
        let newPack = Pack(context: persistentStore.context)
        newPack.id = UUID()
        newPack.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        newPack.gearlist = gearlist
        // Save the newly created Pack
        persistentStore.saveContext()
    }
    /// Function to create a new Pack from the Item Row In Gearlist then pass it back so it can populate as the selected Pack.
    func addNewPackFromItem(using editableData: EditablePackData, gearlist: Gearlist, containerOut: ((Pack) -> ())) {
        let newPack = Pack(context: persistentStore.context)
        newPack.id = UUID()
        newPack.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        newPack.gearlist = gearlist
        // Pass back the newly created Pack
        containerOut(newPack)
        // Save the newly created Pack
        persistentStore.saveContext()
    }
    /// Function to add newly selected items and remove selected items from a specifc pack
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
        container.name = editableData.name.trimmingCharacters(in: .whitespacesAndNewlines)
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
    /// Function to return the packs of a specific gearlist
    func gearlistPacks(gearlist: Gearlist) -> [Pack] {
        let packs = packingGroups.filter( { $0.gearlist == gearlist } )
        return packs
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
    /// Function to return all true packing bools in a specific gearlist
    func gearListTruePackingBools(gearlist: Gearlist) -> [PackingBool] {
        let trueGearlistPackBools: [PackingBool] = truePackBools.filter( { $0.gearlist == gearlist } )
        return trueGearlistPackBools
    }
    //MARK: Sectioning functions
    /// Function for returning a 2D array of items sectioned by their shelf
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
    /// Function for returing a 2D array of Activities sectioned by their ActivityType
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
    /// Function for returning a 2D array of Gearlists sectioned by their Start Year
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
    //MARK: Total Mass Methods
    /// Function to return the total cost from an array of items
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
    /// Function to return the total grams from an array of Items
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
    /// Function to return the total Lbs + Oz of an array of items
    func totalLbsOz(array: [Item]) -> (lbs: String, oz: String) {
        // Taking the intial array of items and mapping the corrosponding mass value while reducing to set a total mass value from the array
        let totalLbs = array.map { Int($0.itemLbs) ?? 0 }.reduce(0, +)
        let totalOz = array.map { Double($0.itemOZ) ?? 0.0 }.reduce(0, +)
        // Doing nessecary math to make sure every 16 ounces gets counted as a pound and then convert final totals of mass units to strings
        let totalLbsString = String(totalLbs + Int((totalOz / 16).rounded(.towardZero)))
        let totalOzString = String(format: "%.2f", totalOz - Double(Int((totalOz / 16).rounded(.towardZero)) * 16))
        return (totalLbsString, totalOzString)
    }
    /// Function to return the total grams of all the items in a specifc gearlist
    func gearlistTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for item in gearlist.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    /// Function to return the total Lbs + Oz of all the items in a specifc gearlist
    func gearlistTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        // Array for holding gearlist Items
        var array = [Item]()
        // Populating Item Array from gearlist Items
        for item in gearlist.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    /// Function to return the total grams of all the items in all the packs in a specific gearlist
    func gearlistPackTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for container in gearlist.packs {
            for item in container.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    /// Function to return the total Lbs + Oz of all the items in all the packs in a specific gearlist
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
    /// Function to return the total grams of all the items in all the piles in a specific gearlist
    func gearlistPileTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for pile in gearlist.piles {
            for item in pile.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    /// Function to return the total Lbs + Oz of all the items in all the packs in a specific gearlist
    func gearlistPileTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        var array = [Item]()
        for pile in gearlist.piles {
            for item in pile.items {
                array.append(item)
            }
        }
        return totalLbsOz(array: array)
    }
    /// Function to return the grams of a specific pack
    func packTotalGrams(pack: Pack) -> String {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    /// Function to return the total Lbs + Oz of a specific pack
    func packTotalLbsOz(pack: Pack) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    /// Function to return the total grams of a specific pile
    func pileTotalGrams(pile: Pile) -> String {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    /// Function to return the total Lbs + Oz of a specific pile
    func pileTotalLbsOz(pile: Pile) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    //MARK: Counter Totals
    /// Function to return the total items in the pack view of a gearlist
    func gearlistPackTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for container in gearlist.packs {
            for _ in container.items {
                counter = counter + 1
            }
        }
        return counter
    }
    /// Function to return the total items in the pile view of a gearlist
    func gearlistPileTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for pile in gearlist.piles {
            for _ in pile.items {
                counter = counter + 1
            }
        }
        return counter
    }
    /// Function to return the total true packingBools of a specifc Gearlist
    func gearlistPackingBoolTotals(gearlist: Gearlist) -> Int {
        let counter = gearListTruePackingBools(gearlist: gearlist).count
        return counter
    }
    //MARK: PDF Export Functions
    /// Function to generate an HTML page with passed in content
    func createHTML(selectedGearlist: Gearlist, pdfInt: Int) -> String {
        //MARK: Converting data in PDF Data Models
        let importGL = gearlists.filter { $0.id == selectedGearlist.id}.first!
        let shedItemArray = sectionByShed(itemArray: importGL.items)
        func diaryCount() -> String {
            let count = importGL.diaries.count
            return String(count)
        }
        func weightCountForStat(type: Int) -> String {
            var value: String = ""
            if type == 0 {
                if Prefs.shared.weightUnit == "g" {
                    value = gearlistTotalGrams(gearlist: importGL)
                } else {
                    let lbOz = gearlistTotalLbsOz(gearlist: importGL)
                    let lb = lbOz.lbs
                    let oz = lbOz.oz
                    value = "\(lb) Lbs + \(oz) Oz"
                }
            } else if type == 1 {
                if Prefs.shared.weightUnit == "g" {
                    value = gearlistPileTotalGrams(gearlist: importGL)
                } else {
                    let lbOz = gearlistPileTotalLbsOz(gearlist: importGL)
                    let lb = lbOz.lbs
                    let oz = lbOz.oz
                    value = "\(lb) Lbs + \(oz) Oz"
                }
            } else if type == 2 {
                if Prefs.shared.weightUnit == "g" {
                    value = gearlistPackTotalGrams(gearlist: importGL)
                } else {
                    let lbOz = gearlistPackTotalLbsOz(gearlist: importGL)
                    let lb = lbOz.lbs
                    let oz = lbOz.oz
                    value = "\(lb) Lbs + \(oz) Oz"
                }
            }
            return value
        }
        func costCountForPilePack(type: String) -> String {
            var value: String = ""
            if type == "pile" {
                var arrayString = [String]()
                for pile in importGL.piles {
                    for item in pile.items {
                        arrayString.append(item.price)
                    }
                }
                let intArray = arrayString.map { Int($0) ?? 0 }
                let total = intArray.reduce(0, +)
                let totalString = String(total)
                value = totalString
            } else if type == "pack" {
                var arrayString = [String]()
                for pack in importGL.packs {
                    for item in pack.items {
                        arrayString.append(item.price)
                    }
                }
                let intArray = arrayString.map { Int($0) ?? 0 }
                let total = intArray.reduce(0, +)
                let totalString = String(total)
                value = totalString
            }
            return value
        }
        func costCount(array: [Item]) -> String {
            let value = "$ \(totalCost(array: array))"
            return value
        }
        func weightCount(array: [Item]) -> String {
            var value: String = ""
            if Prefs.shared.weightUnit == "g" {
                value = "\(totalGrams(array: array)) g"
            } else {
                let lbOz = totalLbsOz(array: array)
                let lb = lbOz.lbs
                let oz = lbOz.oz
                value = "\(lb) Lbs + \(oz) Oz"
            }
            return value
        }
        func itemWeightUnit(item: Item) -> String {
            var value: String = ""
            guard (item.weight == "0") || (item.itemLbs == "0" && item.itemOZ == "0.00") else { return value }
            
            if Prefs.shared.weightUnit == "g" {
                value = "\(item.weight) g"
            } else {
                let lbs = item.itemLbs
                let oz = item.itemLbs
                value = "\(lbs) Lbs \(oz) Oz"
            }
            return value
        }
        func itemNameBrandText(item: Item) -> String {
            let itemName = item.name
            let itemBrand = item.brandName
            if itemName.isEmpty && itemBrand.isEmpty {
                return ""
            } else if itemName.isEmpty && !itemBrand.isEmpty {
                return "\(itemBrand); "
            } else if itemBrand.isEmpty && !itemName.isEmpty {
                return "\(itemName); "
            } else if !itemBrand.isEmpty && !itemName.isEmpty {
                return "\(itemName) | \(itemBrand); "
            } else {
                return ""
            }
        }
        func itemWeightPriceText(item: Item) -> String {
            let itemWeightText = itemWeightUnit(item: item)
            let itemPriceText = item.price
            if itemWeightText.isEmpty && itemPriceText.isEmpty {
                return ""
            } else if itemPriceText.isEmpty && !itemWeightText.isEmpty {
                return "\(itemWeightText); "
            } else if itemWeightText.isEmpty && !itemPriceText.isEmpty {
                return "\(itemPriceText); "
            } else if !itemWeightText.isEmpty && !itemPriceText.isEmpty {
                return "\(itemWeightText) | \(itemPriceText); "
            } else {
                return ""
            }
        }
        func pdfType() -> String {
            if pdfInt == 0 {
                return "List View"
            } else if pdfInt == 1 {
                return "Pile View"
            } else if pdfInt == 2 {
                return "Pack View"
            } else if pdfInt == 3 {
                return "Diary View"
            } else {
                return ""
            }
        }
        func pdfLocationCountryText() -> String {
            let location = importGL.location ?? ""
            let country = importGL.country ?? ""
            if location.isEmpty && country.isEmpty {
                return ""
            } else if location.isEmpty && !country.isEmpty {
                return country
            } else if country.isEmpty && !location.isEmpty {
                return location
            } else if !location.isEmpty && !country.isEmpty {
                return "\(location) | \(country)"
            } else {
                return ""
            }
        }
        func pdfDate() -> String {
            var text: String = ""
            text = Date().monthDayYearDateText()
            return text
        }
        func pdfTime() -> String {
            var text: String = ""
            text = Date().hourMinuteText()
            return text
        }
        func pdfStats() -> String {
            if pdfInt == 0 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(String(shedItemArray.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(String(importGL.items.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: importGL.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: importGL.items))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 1 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Piles</p>
                            <p class="statVal">\(String(importGL.pileCount))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(gearlistPileTotalItems(gearlist: importGL))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCountForStat(type: 1))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCountForPilePack(type: "pile"))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 2 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(String(importGL.packs.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(gearlistPackTotalItems(gearlist: importGL))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCountForStat(type: 2))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCountForPilePack(type: "pack"))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 3 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Entries</p>
                            <p class="statVal">\(diaryCount())</p>
                        </div>
                        <!--
                        """
            } else {
                return ""
            }
        }
        func sectionItems(array: [Item]) -> String {
            var text: String = ""
            for item in array {
                text.append(contentsOf:
                """
                <li class="item">\(itemNameBrandText(item: item))\(itemWeightPriceText(item: item))\(item.detail)</li>
                """
                )
            }
            return text
        }
        func pdfItemSections() -> String {
            var finalText: String = "-->"
            var textFirst: String = ""
            if pdfInt == 0 {
                for shelf in shedItemArray {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf.title) \(weightCount(array: shelf.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: shelf.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 1 {
                for pile in importGL.piles {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(pile.name) \(weightCount(array: pile.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: pile.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 2 {
                for pack in importGL.packs {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(pack.name) \(weightCount(array: pack.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: pack.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 3 {
                for diary in importGL.diaries {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(diary.name)</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(diary.details)<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            }
            finalText.append(contentsOf: "<!--")
            return finalText
        }
        //Get HTML Template URL from Bundle
        guard let htmlFile = Bundle.main.url(forResource: "gearListTemplate", withExtension: "html")
            else { fatalError("Error locating HTML file.") }
        //Convert HTML URL Contents to String
        guard let htmlContent = try? String(contentsOf: htmlFile)
            else { fatalError("Error getting HTML file content.") }
        //Get Logo URL from Bundle
        guard let imageURL = Bundle.main.url(forResource: "gearShedBlack", withExtension: "png")
            else { fatalError("Error locating image file.") }
        //Get HelveticaNeue Fonts URL from Bundle
        guard let hevNeue = Bundle.main.url(forResource: "pHelveticaNeue", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueThin = Bundle.main.url(forResource: "pHelveticaNeueThin", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueIt = Bundle.main.url(forResource: "pHelveticaNeueIt", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueLt = Bundle.main.url(forResource: "pHelveticaNeueLt", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueMed = Bundle.main.url(forResource: "pHelveticaNeueMed", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueHv = Bundle.main.url(forResource: "pHelveticaNeueHv", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueBold = Bundle.main.url(forResource: "pHelveticaNeueBold", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        guard let hevNeueBlackCond = Bundle.main.url(forResource: "pHelveticaNeueBlackCond", withExtension: "ttf")
            else { fatalError("Error locating font file.") }
        // Replace HTMML placeholders with values
        let finalHTML = htmlContent
            .replacingOccurrences(of: "#hevNeue#", with: hevNeue.description)
            .replacingOccurrences(of: "#hevNeueThin#", with: hevNeueThin.description)
            .replacingOccurrences(of: "#hevNeueIt#", with: hevNeueIt.description)
            .replacingOccurrences(of: "#hevNeueLt#", with: hevNeueLt.description)
            .replacingOccurrences(of: "#hevNeueMed#", with: hevNeueMed.description)
            .replacingOccurrences(of: "#hevNeueHv#", with: hevNeueHv.description)
            .replacingOccurrences(of: "#hevNeueBold#", with: hevNeueBold.description)
            .replacingOccurrences(of: "#hevNeueBlackCond#", with: hevNeueBlackCond.description)
            .replacingOccurrences(of: "#USERNAME#", with: "\(Prefs.shared.pdfUserName)'s")
            .replacingOccurrences(of: "#GEARLIST_TITLE#", with: "\(importGL.name)")
            .replacingOccurrences(of: "#GEARLIST_START#", with: "\(importGL.startDate?.monthDayYearDateText() ?? "")")
            .replacingOccurrences(of: "#LOCATION_COUNTRY#", with: pdfLocationCountryText())
            .replacingOccurrences(of: "#PDF_TYPE#", with: pdfType())
            .replacingOccurrences(of: "#DATE#", with: pdfDate())
            .replacingOccurrences(of: "#TIME#", with: pdfTime())
            .replacingOccurrences(of: "{{IMG_SRC}}", with: imageURL.description)
            .replacingOccurrences(of: "#STAT_BAR#", with: pdfStats())
            .replacingOccurrences(of: "#ITEM_SECTION#", with: pdfItemSections())
        return finalHTML
    }
    /// Function to convert the html page to a PDF and present a print screen
    func printPDF(selectedGearlist: Gearlist, pdfInt: Int) {
        let printController = UIPrintInteractionController.shared
        let printFormatter = UIMarkupTextPrintFormatter(markupText: createHTML(selectedGearlist: selectedGearlist, pdfInt: pdfInt))
        printController.printFormatter = printFormatter
        printController.present(animated: true) { (controller, completion, error) in
            print(error ?? "Print controller presented.")
        }
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
