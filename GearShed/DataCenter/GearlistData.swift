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
    
    private let listGroupController: NSFetchedResultsController<Cluster>
    @Published var listgroups = [Cluster]()
    
    private let packingGroupController: NSFetchedResultsController<Container>
    @Published var packingGroups = [Container]()
    
    private let trueContainerBoolController: NSFetchedResultsController<ContainerBool>
    @Published var trueContainerBools = [ContainerBool]()
    
    private let packingBoolsController: NSFetchedResultsController<ContainerBool>
    @Published var packingBools = [ContainerBool]()
    
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
        
        let listGroupRequest: NSFetchRequest<Cluster> = Cluster.fetchRequest()
        listGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        listGroupController = NSFetchedResultsController(fetchRequest: listGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let packingGroupRequest: NSFetchRequest<Container> = Container.fetchRequest()
        packingGroupRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        packingGroupController = NSFetchedResultsController(fetchRequest: packingGroupRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let trueContainerBoolRequest: NSFetchRequest<ContainerBool> = ContainerBool.fetchRequest()
        trueContainerBoolRequest.sortDescriptors = [NSSortDescriptor(key: "isPacked_", ascending: true)]
        trueContainerBoolRequest.predicate = NSPredicate(format: "isPacked_ == %d", true)
        
        trueContainerBoolController = NSFetchedResultsController(fetchRequest: trueContainerBoolRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let packingBoolRequest: NSFetchRequest<ContainerBool> = ContainerBool.fetchRequest()
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
        trueContainerBoolController.delegate = self
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
            try trueContainerBoolController.performFetch()
            trueContainerBools = trueContainerBoolController.fetchedObjects ?? []
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
        trueContainerBools = trueContainerBoolController.fetchedObjects ?? []
        packingBools = packingBoolsController.fetchedObjects ?? []
    }
    
    func gearlistContainers(gearlist: Gearlist) -> [Container] {
        let containers = packingGroups.filter( { $0.gearlist == gearlist } )
        return containers
    }
    
    func gearlistClusters(gearlist: Gearlist) -> [Cluster] {
        let clusters = listgroups.filter( { $0.gearlist == gearlist } )
        return clusters
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
        gearlist.clusters.forEach({ $0.objectWillChange.send() })
        gearlist.containers.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a Gearlist
    func deleteGearlist(gearlist: Gearlist) {
        for item in gearlist.items {
            let containerBool = item.gearlistContainerBool(gearlist: gearlist)!
            persistentStore.context.delete(containerBool)
        }
        
        for cluster in gearlist.clusters {
            persistentStore.context.delete(cluster)
        }
        
        for container in gearlist.containers {
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
            createNewContainerBool(gearlist: newGearlist, item: item)
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
            createNewContainerBool(gearlist: gearlist, item: item)
        }
        persistentStore.saveContext()
    }
    
    /// Function to update a Gearlists Items and create an associated packingBool upon entry.
    func updateGearlistItems(gearlist: Gearlist, addingItems: [Item], removingItems: [Item]) {
        for item in addingItems {
            gearlist.addToItems_(item)
            createNewContainerBool(gearlist: gearlist, item: item)
        }
        
        for item in removingItems {
            removeItemFromGearlist(item: item, gearlist: gearlist)
        }
        persistentStore.saveContext()
    }
    
    /// Function to remove an Item from a Cluster + associated clean up.
    func removeItemFromGearlist(item: Item, gearlist: Gearlist) {
        // First lets delete the items containerBool
        if let containerBool = item.gearlistContainerBool(gearlist: gearlist) {
            persistentStore.context.delete(containerBool)
        }
        // Second lets remove the item -> container relationship
        if let container = item.gearlistContainer(gearlist: gearlist) {
            item.removeFromContainers_(container)
        }
        // Third lets remove the item from its cluster
        if let cluster = item.gearlistCluster(gearlist: gearlist) {
            item.removeFromClusters_(cluster)
        }
        
        // And finally remove the item from the gearlist
        gearlist.removeFromItems_(item)
        // Save the changes.
        persistentStore.saveContext()
    }
    /// Function to remove an Item from a Cluster.
    func removeItemFromCluster(item: Item, cluster: Cluster) {
        cluster.removeFromItems_(item)
        persistentStore.saveContext()
    }
    /// Function to remove an Item from a Container.
    func removeItemFromContainer(item: Item, container: Container) {
        item.containerContainerBool(container: container)?.isPacked = false
        item.containerContainerBool(container: container)?.container = nil
        container.removeFromItems_(item)
        persistentStore.saveContext()
    }
    
    
    // MARK: Cluster Methods
    /// Function to create a new Cluster.
    func addNewCluster(using editableData: EditableClusterData, gearlist: Gearlist) {
        let newCluster = Cluster(context: persistentStore.context)
        newCluster.id = UUID()
        newCluster.name = editableData.name
        newCluster.gearlist = gearlist
        persistentStore.saveContext()
    }
    /// Function to create a new Cluster from the Item Row In Gearlist then pass it back so it can populate as the selected Cluster.
    func addNewClusterFromItem(using editableData: EditableClusterData, gearlist: Gearlist, clusterOut: ((Cluster) -> ())) {
        let newCluster = Cluster(context: persistentStore.context)
        newCluster.id = UUID()
        newCluster.name = editableData.name
        newCluster.gearlist = gearlist
        // Pass back the newly created Cluster
        clusterOut(newCluster)
        // Save the newly created cluster. 
        persistentStore.saveContext()
    }
    
    /// Function to update a Piles items
    func updateClusterItems(addingItems: [Item], removingItems: [Item], pile: Cluster) {
        for item in addingItems {
            pile.addToItems_(item)
        }
        for item in removingItems {
            pile.removeFromItems_(item)
        }
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated cluster updated and remove the reference to the old one.
    func updateItemCluster(newCluster: Cluster?, oldCluster: Cluster?, item: Item) {
        if let oldCluster = oldCluster {
            item.removeFromClusters_(oldCluster)
        }
        item.addToClusters_(newCluster!)
        
        persistentStore.saveContext()
    }
    
    /// Function to edit Cluster values.
    func updateCluster(using editableData: EditableClusterData) {
        let cluster = editableData.associatedCluster
        cluster.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to delete a Cluster.
    func deleteCluster(cluster: Cluster) {
        persistentStore.context.delete(cluster)
        persistentStore.saveContext()
    }
    
    // MARK: Container Methods
    /// Function to create a new Container.
    func addNewContainer(using editableData: EditableContainerData, gearlist: Gearlist) {
        let newContainer = Container(context: persistentStore.context)
        newContainer.id = UUID()
        newContainer.name = editableData.name
        newContainer.gearlist = gearlist
        // Save the newly created Container
        persistentStore.saveContext()
    }
    /// Function to create a new Container from the Item Row In Gearlist then pass it back so it can populate as the selected Container.
    func addNewContainerFromItem(using editableData: EditableContainerData, gearlist: Gearlist, containerOut: ((Container) -> ())) {
        let newContainer = Container(context: persistentStore.context)
        newContainer.id = UUID()
        newContainer.name = editableData.name
        newContainer.gearlist = gearlist
        // Pass back the newly created Container
        containerOut(newContainer)
        // Save the newly created Container
        persistentStore.saveContext()
    }
    
    func updateContainerItems(addingItems: [Item], removingItems: [Item], pack: Container) {
        for item in addingItems {
            pack.addToItems_(item)
            item.containerContainerBool(container: pack)?.container = pack
        }
        for item in removingItems {
            pack.removeFromItems_(item)
            item.containerContainerBool(container: pack)?.container = nil
        }
        persistentStore.saveContext()
    }
    
    /// Function to keep an Items associated Container updated and remove the reference to the old one.
    func updateItemContainer(newContainer: Container?, oldContainer: Container?, item: Item, gearlist: Gearlist) {

        if let oldContainer = oldContainer {
            item.removeFromContainers_(oldContainer)
        }
        item.addToContainers_(newContainer!)
        
        item.gearlistContainerBool(gearlist: gearlist)?.container = newContainer!
        
        persistentStore.saveContext()
    }
    /// Function to edit Container values.
    func updateContainer(using editableData: EditableContainerData) {
        let container = editableData.associatedContainer
        container.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to delete a Container.
    func deleteContainer(container: Container) {
        for item in container.items {
            item.containerContainerBool(container: container)?.isPacked = false
        }
        persistentStore.context.delete(container)
        persistentStore.saveContext()
    }
    
    // MARK: ContainerBool Methods
    /// Function to create a new containerBool for an Item in a Gearlist.
    func createNewContainerBool(gearlist: Gearlist, item: Item) {
        let newContainerBool = ContainerBool(context: persistentStore.context)
        newContainerBool.id = UUID()
        newContainerBool.isPacked = false
        newContainerBool.gearlist = gearlist
        newContainerBool.container = nil
        newContainerBool.item = item
        persistentStore.saveContext()
    }
    /// Function to toggle the state of wether an Item is packed or not.
    func toggleContainerBoolState(containerBool: ContainerBool) {
        if containerBool.isPacked == true {
            containerBool.isPacked = false
        } else {
            containerBool.isPacked = true
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
        
    func gearListTrueContainerBools(gearlist: Gearlist) -> [ContainerBool] {
        let trueGearlistContainerBools: [ContainerBool] = trueContainerBools.filter( { $0.gearlist == gearlist } )
        return trueGearlistContainerBools
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
        for container in gearlist.containers {
            for item in container.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    func gearlistPackTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        // Array for holding gearlist Items
        var array = [Item]()
        for container in gearlist.containers {
            for item in container.items {
                array.append(item)
            }
        }
        return totalLbsOz(array: array)
    }
    func gearlistPileTotalGrams(gearlist: Gearlist) -> String {
        var array = [Item]()
        for cluster in gearlist.clusters {
            for item in cluster.items {
                array.append(item)
            }
        }
        return totalGrams(array: array)
    }
    func gearlistPileTotalLbsOz(gearlist: Gearlist) -> (lbs: String, oz: String) {
        var array = [Item]()
        for cluster in gearlist.clusters {
            for item in cluster.items {
                array.append(item)
            }
        }
        return totalLbsOz(array: array)
    }
    func packTotalGrams(pack: Container) -> String {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    func packTotalLbsOz(pack: Container) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pack.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    func pileTotalGrams(pile: Cluster) -> String {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalGrams(array: array)
    }
    func pileTotalLbsOz(pile: Cluster) -> (lbs: String, oz: String) {
        var array = [Item]()
        for item in pile.items {
            array.append(item)
        }
        return totalLbsOz(array: array)
    }
    
    //MARK: Counter Totals
    
    func gearlistContainerTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for container in gearlist.containers {
            for _ in container.items {
                counter = counter + 1
            }
        }
        return counter
    }
    
    func gearlistClusterTotalItems(gearlist: Gearlist) -> Int {
        var counter: Int = 0
        for cluster in gearlist.clusters {
            for _ in cluster.items {
                counter = counter + 1
            }
        }
        return counter
    }
    
    func gearlistContainerBoolTotals(gearlist: Gearlist) -> Int {
        let counter = gearListTrueContainerBools(gearlist: gearlist).count
        return counter
    }
    
}

/// Function to tie the relationship between an Item and a Container.
/*func addPackingGroupToItem(item: Item, packingGroup: Container) {
    item.addToPackingGroups_(packingGroup)
    persistentStore.saveContext()
}*/


/// Function to create a new packingBool for an Item in a packing Group iff that bool does not yet exist.
/*func createNewContainerBool(container: Container, item: Item) {
    if item.containerContainerBool(container: container, item: item) != nil {
        return
    } else {
        let newContainerBool = PackingBool(context: persistentStore.context)
        newContainerBool.id = UUID()
        newContainerBool.isPacked = false
        newContainerBool.container = container
        newContainerBool.item = item
    }
    persistentStore.saveContext()
}*/

/// Function to add Items to a List Group
/*func addItemsToCluster(listGroup: Cluster, itemArray: [Item]) {
    for item in itemArray {
        listGroup.addToItems_(item)
    }
    persistentStore.saveContext()
}*/



/// Function to remove an Item from a Cluster + associated clean up.
/*func removeItemFromList(item: Item, listGroup: Cluster, packingGroup: PackingGroup?) {
    // If the item has a packingGroup remove it & if so remove the associated packingBool as well.
    if let packingGroup = packingGroup {
        item.removeFromPackingGroups_(packingGroup)
        packingGroup.removeFromItems_(item)
        if let packingBool = item.packingGroupPackingBool(packingGroup: packingGroup, item: item) {
            persistentStore.context.delete(packingBool)
        }
    }
    // Remove the Item -> Cluster relationship.
    item.removeFromListgroups_(listGroup)
    // Save the changes.
    persistentStore.saveContext()
}*/
/// Function to create a new Cluster.
/*func createNewCluster(gearlist: Gearlist) {
    let newCluster = Cluster(context: persistentStore.context)
    newCluster.id = UUID()
    newCluster.name_ = ""
    newCluster.gearlist = gearlist
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
