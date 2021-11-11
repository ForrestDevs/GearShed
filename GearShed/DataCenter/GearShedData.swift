//
//  GearShedData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import CoreData

final class GearShedData: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    // MARK: Data Publishing Operations
    
    let persistentStore: PersistentStore
        
    private let itemsController: NSFetchedResultsController<Item>
    @Published var items = [Item]()
    
    private let favItemsController: NSFetchedResultsController<Item>
    @Published var favItems = [Item]()
    
    private let regretItemsController: NSFetchedResultsController<Item>
    @Published var regretItems = [Item]()
    
    private let wishlistItemsController: NSFetchedResultsController<Item>
    @Published var wishListItems = [Item]()
    
    let shedsController: NSFetchedResultsController<Shed>
    @Published var sheds = [Shed]()
    
    private let brandsController: NSFetchedResultsController<Brand>
    @Published var brands = [Brand]()
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        // MARK: Item Fetch Requests
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        itemRequest.predicate = NSPredicate(format: "wishlist_ == %d", false)
        
        itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let favItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        favItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        favItemRequest.predicate = NSPredicate(format: "isFavourite_ == %d", true)
        
        favItemsController = NSFetchedResultsController(fetchRequest: favItemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let regretItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        regretItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        regretItemRequest.predicate = NSPredicate(format: "isRegret_ == %d", true)
        
        regretItemsController = NSFetchedResultsController(fetchRequest: regretItemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let wishlistItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        wishlistItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        wishlistItemRequest.predicate = NSPredicate(format: "wishlist_ == %d", true)
        
        wishlistItemsController = NSFetchedResultsController(fetchRequest: wishlistItemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Shed Fetch Requests
        let shedRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        shedRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        shedsController = NSFetchedResultsController(fetchRequest: shedRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Brand Fetch Requests
        let brandRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        brandRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        brandsController = NSFetchedResultsController(fetchRequest: brandRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Assign Entities to corosponding arrays
        super.init()
        itemsController.delegate = self
        favItemsController.delegate = self
        regretItemsController.delegate = self
        wishlistItemsController.delegate = self
        shedsController.delegate = self
        brandsController.delegate = self
        
        do {
            try itemsController.performFetch()
            items = itemsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Items")
        }
        
        do {
            try regretItemsController.performFetch()
            regretItems = regretItemsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Regret Items")
        }
        
        do {
            try favItemsController.performFetch()
            favItems = favItemsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Fav Items")
        }
        
        do {
            try wishlistItemsController.performFetch()
            wishListItems = wishlistItemsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Fav Items")
        }
        
        do {
            try shedsController.performFetch()
            sheds = shedsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Sheds")
        }
        
        do {
            try brandsController.performFetch()
            brands = brandsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Brands")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        items = itemsController.fetchedObjects ?? []
        favItems = favItemsController.fetchedObjects ?? []
        regretItems = regretItemsController.fetchedObjects ?? []
        wishListItems = wishlistItemsController.fetchedObjects ?? []
        sheds = shedsController.fetchedObjects ?? []
        brands = brandsController.fetchedObjects ?? []
    }
    
    // MARK: Data CUD Operations
    
    // Item ------------------------------------------------------------------------------------------------
    /// Function to create a new Item using the temp stored data.
    func addNewItem(using editableData: EditableItemData) {
        let newItem = Item(context: persistentStore.context)
        newItem.id = UUID()
        newItem.name = editableData.name
        newItem.detail = editableData.details
        newItem.quantity = Int(editableData.quantity)
        newItem.weight = editableData.weight
        newItem.price = editableData.price
        newItem.wishlist = editableData.wishlist
        newItem.shed = editableData.shed!
        newItem.brand = editableData.brand!
        newItem.datePurchased = editableData.datePurchased
        persistentStore.saveContext()
    }
    /// Function to update an Item's values using the temp stored data.
    func updateItem(using editableData: EditableItemData) {
        let item = editableData.associatedItem
        item.name = editableData.name
        item.detail = editableData.details
        item.quantity = Int(editableData.quantity)
        item.weight = editableData.weight
        item.price = editableData.price
        item.wishlist = editableData.wishlist
        item.isFavourite = editableData.isFavourite
        item.isRegret = editableData.isRegret
        item.shed = editableData.shed!
        item.brand = editableData.brand!
        item.datePurchased = editableData.datePurchased
        
        item.gearlists.forEach({ $0.objectWillChange.send() })
        item.clusters.forEach({ $0.objectWillChange.send() })
        item.containers.forEach({ $0.objectWillChange.send() })
        item.containerBools.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete an Item and move all items at the brand to the Unknown Brand.
    func deleteItem(item: Item) {
        // remove the reference to this item from its associated shed & brand
        // by resetting its (real, Core Data) shed & brand to nil
        item.shed_ = nil
        item.brand_ = nil
        
        persistentStore.context.delete(item)
        persistentStore.saveContext()
    }
    
    // Brand ------------------------------------------------------------------------------------------------
    /// Function to create a new Brand using the temp stored data.
    func addNewBrand(using editableData: EditableBrandData) {
        let newBrand = Brand(context: persistentStore.context)
        newBrand.id = UUID()
        newBrand.name_ = editableData.brandName
        persistentStore.saveContext()
    }
    /// Function to create a new Brand from the Item entry form then pass It back so it can populate as the selected Brand.
    func addNewBrandFromItem(using editableData: EditableBrandData, brandOut: ((Brand) -> ())) {
        let newBrand = Brand(context: persistentStore.context)
        newBrand.id = UUID()
        newBrand.name_ = editableData.brandName
        persistentStore.saveContext()
        brandOut(newBrand)
    }
    /// Function to update a Brand's values using the temp stored data.
    func updateBrand(using editableData: EditableBrandData) {
        let brand = editableData.associatedBrand
        brand.name_ = editableData.brandName
        brand.items.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a brand and move all items at the brand to the Unknown Brand.
    func deleteBrand(brand: Brand)  {
        // you cannot delete the unknownBrand
        guard brand.unBrandID_ != kUnknownBrandID else { return }
        
        // Get list of all items for this brand so we can work with them
        let itemsAtThisBrand = brand.items
        
        // reset brand associated with each of these Items to the unknownBrand
        // (which in turn, removes the current association with brand). additionally,
        // this could affect each item's computed properties
        let theUnknownBrand = unknownBrand()
        itemsAtThisBrand.forEach({ $0.brand = theUnknownBrand })
        
        // now finish the deletion and save
        persistentStore.context.delete(brand)
        persistentStore.saveContext()
    }
    
    // Shed ------------------------------------------------------------------------------------------------
    /// Function to create a new Shed using the temp stored data.
    func addNewShed(using editableData: EditableShedData) {
        let newShed = Shed(context: persistentStore.context)
        newShed.id = UUID()
        newShed.name_ = editableData.shedName
        persistentStore.saveContext()
    }
    /// Function to create a new Shed from the Item entry form, then pass it back so it can populate as the selected Shed.
    func addNewShedFromItem(using editableData: EditableShedData, shedOut: ((Shed) -> ())) {
        let newShed = Shed(context: persistentStore.context)
        newShed.id = UUID()
        newShed.name_ = editableData.shedName
        persistentStore.saveContext()
        shedOut(newShed)
    }
    /// Function to update a Shed's values using the temp stored data.
    func updateShed(using editableData: EditableShedData) {
        let shed = editableData.associatedShed
        //editableData.associatedShed.name_ = editableData.shedName
        shed.name_ = editableData.shedName
        shed.items.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a shed and move all items at the shed to the Unknown Shed.
    func deleteShed(shed: Shed) {
        // you cannot delete the unknownBrand
        guard shed.unShedID_ != kUnknownShedID else { return }
        
        // Get list of all items for this brand so we can work with them
        let itemsAtThisShed = shed.items
        
        // reset brand associated with each of these Items to the unknownBrand
        // (which in turn, removes the current association with brand). additionally,
        // this could affect each item's computed properties
        let theUnknownShed = unknownShed()
        itemsAtThisShed.forEach({ $0.shed = theUnknownShed })
        
        // now finish the deletion and save
        persistentStore.context.delete(shed)
        persistentStore.saveContext()
    }
    
    // Unknown Shed + Brand ---------------------------------------------------------------------------------
    /// Function to create an UnknownBrand and return it when needed.
    func createUnknownBrand() -> Brand {
        let unbranded = Brand(context: persistentStore.context)
        unbranded.name_ = kUnknownBrandName
        unbranded.id = UUID()
        unbranded.unBrandID_ = kUnknownBrandID
        kUnknownBrandUUID = unbranded.id
        persistentStore.saveContext()
        return unbranded
    }
    /// Function to check if an unknownBrand exisits if it does return it, if not create it then return
    func unknownBrand() -> Brand {
        let fetchRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "unBrandID_ == %d", kUnknownBrandID)
        do {
            let brand = try persistentStore.context.fetch(fetchRequest)
            if brand.count >= 1 {
                return brand[0]
            } else {
                return createUnknownBrand()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown brand: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    /// Function to create an UnknownShed and return it when needed.
    func createUnknownShed() -> Shed {
        let unSheded = Shed(context: persistentStore.context)
        unSheded.name_ = kUnknownBrandName
        unSheded.id = UUID()
        unSheded.unShedID_ = kUnknownShedID
        persistentStore.saveContext()
        return unSheded
    }
    /// Function to check if an unknownShed exisits if it does return it, if not create it then return
    func unknownShed() -> Shed {
        let fetchRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "unShedID_ == %d", kUnknownShedID)
        
        do {
            let shed = try persistentStore.context.fetch(fetchRequest)
            if shed.count >= 1 {
                return shed[0]
            } else {
                return createUnknownShed()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown brand: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    // MARK: Data Sectioning Functions
    
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
    
    func sectionByBrand(itemArray: [Item]) -> [SectionBrandData] {
        var completedSectionData = [SectionBrandData]()
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByShed = Dictionary(grouping: itemArray, by: { $0.brand })
        
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByShed.keys.sorted() {
            completedSectionData.append(SectionBrandData(title: key.name,brand: key,items: dictionaryByShed[key]!))
        }
        return completedSectionData
    }
    
    // MARK: - Total Functions

    func totalWeight(array: [Item]) -> String {
        var arrayString = [String]()
        for x in array {
            arrayString.append(x.weight)
        }
        let intArray = arrayString.map { Int($0) ?? 0 }
        let total = intArray.reduce(0, +)
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
    
    func totalFavs(array: [Item]) -> String {
        let favItems = array.filter { $0.isFavourite }
        return String(favItems.count)
    }
    
    func totalRegrets(array: [Item]) -> String {
        let regretItems = array.filter { $0.isRegret }
        return String(regretItems.count)
    }
}
