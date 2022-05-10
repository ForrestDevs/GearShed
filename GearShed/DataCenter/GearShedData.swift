//
//  GearShedData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class GearShedData: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    @Published var showAll: Bool = true
    // MARK: Data Publishing Operations
    let persistentStore: PersistentStore
    private let itemsController: NSFetchedResultsController<Item>
    @Published var items = [Item]()
//    private let itemImagesController: NSFetchedResultsController<ItemImage>
//    @Published var itemImages = [ItemImage]()
    private let itemDiariesController: NSFetchedResultsController<ItemDiary>
    @Published var itemDiaries = [ItemDiary]()
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
        //itemRequest.predicate = NSPredicate(format: "isWishlist_ == %d", false)
        
        itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
//        let itemImagesRequest: NSFetchRequest<ItemImage> = ItemImage.fetchRequest()
//        itemImagesRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
//        itemImagesController = NSFetchedResultsController(fetchRequest: itemImagesRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let itemDiaryRequest: NSFetchRequest<ItemDiary> = ItemDiary.fetchRequest()
        itemDiaryRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        itemDiariesController = NSFetchedResultsController(fetchRequest: itemDiaryRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
            
        
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
        wishlistItemRequest.predicate = NSPredicate(format: "isWishlist_ == %d", true)
        
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
        //itemImagesController.delegate = self
        itemDiariesController.delegate = self
        
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
        
//        do {
//            try itemImagesController.performFetch()
//            itemImages = itemImagesController.fetchedObjects ?? []
//        } catch {
//            print("Failed to fetch ItemsImages")
//        }
        
        do {
            try itemDiariesController.performFetch()
            itemDiaries = itemDiariesController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch ItemsDiaries")
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
        itemDiaries = itemDiariesController.fetchedObjects ?? []
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
        newItem.itemLbs = editableData.lbs
        newItem.itemOZ = editableData.oz

        newItem.price = editableData.price
        newItem.isWishlist = editableData.isWishlist
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
        item.itemLbs = editableData.lbs
        item.itemOZ = editableData.oz
        
        item.price = editableData.price
        item.isWishlist = editableData.isWishlist
        item.isFavourite = editableData.isFavourite
        item.isRegret = editableData.isRegret
        item.shed = editableData.shed!
        item.brand = editableData.brand!
        item.datePurchased = editableData.datePurchased
        item.gearlists.forEach({ $0.objectWillChange.send() })
        item.piles.forEach({ $0.objectWillChange.send() })
        item.packs.forEach({ $0.objectWillChange.send() })
        item.packingBools.forEach({ $0.objectWillChange.send() })
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
    // MARK: Item Diary Stuff ---------------------------------------------------------------------------------
    /// Function to add a new ItemDiary using editableData.
    func addNewItemDiary(using editableData: EditableDiaryData) {
        let newDiary = ItemDiary(context: persistentStore.context)
        newDiary.id = UUID()
        newDiary.name = editableData.item!.name
        newDiary.details = editableData.details
        newDiary.item = editableData.item!
        newDiary.gearlist = editableData.gearlist
        persistentStore.saveContext()
    }
    /// Function to update an existing ItemDiary using editableData.
    func updateItemDiary(using editableData: EditableDiaryData) {
        let diary = editableData.associatedDiary
        diary.details = editableData.details
        persistentStore.saveContext()
    }
    /// Function to update an existing ItemDiary using editableData.
    func updateItemDiaryFromNewEntry(item: Item, gearlist: Gearlist, details: String) {
        for diary in item.diaries {
            if diary.gearlist == gearlist {
                diary.details = details
            }
        }
        persistentStore.saveContext()
    }
    /// Function to delete an ItemDiary
    func deleteItemDiary(diary: ItemDiary) {
        persistentStore.context.delete(diary)
        persistentStore.saveContext()
    }
    // Brand ------------------------------------------------------------------------------------------------
    /// Function to create a new Brand using the temp stored data.
    func addNewBrand(using editableData: EditableBrandData) {
        let newBrand = Brand(context: persistentStore.context)
        newBrand.id = UUID()
        newBrand.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to create a new Brand from the Item entry form then pass It back so it can populate as the selected Brand.
    func addNewBrandFromItem(using editableData: EditableBrandData, brandOut: ((Brand) -> ())) {
        let newBrand = Brand(context: persistentStore.context)
        newBrand.id = UUID()
        newBrand.name = editableData.name
        persistentStore.saveContext()
        brandOut(newBrand)
    }
    /// Function to update a Brand's values using the temp stored data.
    func updateBrand(using editableData: EditableBrandData) {
        let brand = editableData.associatedBrand
        brand.name = editableData.name
        brand.items.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a brand and move all items at the brand to the Unknown Brand.
    func deleteBrand(brand: Brand)  {
        if brand.unBrandID_ == kUnknownBrandID && brand.items.count >= 1 {
            return
        } else {
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
        // you cannot delete the unknownBrand
        //guard brand.unBrandID_ != kUnknownBrandID else { return }
        
        
    }
    // Shed ------------------------------------------------------------------------------------------------
    /// Function to create a new Shed using the temp stored data.
    func addNewShed(using editableData: EditableShedData) {
        let newShed = Shed(context: persistentStore.context)
        newShed.id = UUID()
        newShed.name = editableData.name
        persistentStore.saveContext()
    }
    /// Function to add multiple sheds at a time.
//    func addMultipleSheds(using editableData: EditableShedData) {
//        for shedName in editableData.nameArray {
//            let newShed = Shed(context: persistentStore.context)
//            newShed.id = UUID()
//            newShed.name = shedName
//        }
//        persistentStore.saveContext()
//    }
    /// Function to create a new Shed from the Item entry form, then pass it back so it can populate as the selected Shed.
    func addNewShedFromItem(using editableData: EditableShedData, shedOut: ((Shed) -> ())) {
        let newShed = Shed(context: persistentStore.context)
        newShed.id = UUID()
        newShed.name = editableData.name
        persistentStore.saveContext()
        shedOut(newShed)
    }
    /// Function to update a Shed's values using the temp stored data.
    func updateShed(using editableData: EditableShedData) {
        let shed = editableData.associatedShed
        //editableData.associatedShed.name_ = editableData.shedName
        shed.name = editableData.name
        shed.items.forEach({ $0.objectWillChange.send() })
        persistentStore.saveContext()
    }
    /// Function to delete a shed and move all items at the shed to the Unknown Shed.
    func deleteShed(shed: Shed) {
        // you cannot delete the unknownBrand
        if shed.unShedID_ == kUnknownShedID && shed.items.count >= 1 {
            return
        } else {
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
        //guard shed.unShedID_ != kUnknownShedID else { return }
    }
    // Unknown Shed + Brand ---------------------------------------------------------------------------------
    /// Function to create an UnknownBrand and return it when needed.
    func createUnknownBrand() -> Brand {
        let unbranded = Brand(context: persistentStore.context)
        unbranded.name = "No Brand"
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
        unSheded.name = "No Shed"
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
            fatalError("Error fetching unknown shed: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    // MARK: Data Sectioning Functions
    /// Function to return a 2D array with Items grouped by Shed
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
    /// Function to return a 2D array with Items grouped by Brand
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
    /// Function to return total grams of an array of items.
    func totalGrams(array: [Item]) -> String {
        var arrayString = [String]()
        for x in array {
            arrayString.append(x.weight)
        }
        let intArray = arrayString.map { Int($0) ?? 0 }
        let total = intArray.reduce(0, +)
        let totalString = String(total)
        return totalString
    }
    /// Function to return total lbs + oz of an array of items.
    func totalLbsOz(array: [Item]) -> (lbs: String, oz: String) {
        // Taking the intial array of items and mapping the corrosponding mass value while reducing to set a total mass value from the array
        let totalLbs = array.map { Int($0.itemLbs) ?? 0 }.reduce(0, +)
        let totalOz = array.map { Double($0.itemOZ) ?? 0.0 }.reduce(0, +)
        // Doing nessecary math to make sure every 16 ounces gets counted as a pound and then convert final totals of mass units to strings
        let totalLbsString = String(totalLbs + Int((totalOz / 16).rounded(.towardZero)))
        let totalOzString = String(format: "%.2f", totalOz - Double(Int((totalOz / 16).rounded(.towardZero)) * 16))
        return (totalLbsString, totalOzString)
    }
    /// Function to return the total cost of an array of items.
    func totalCost(array: [Item]) -> String {
        var arrayString = [String]()
        for x in array {
            arrayString.append(x.price)
        }
        let intArray = arrayString.map { Int($0) ?? 0 }
        let total = intArray.reduce(0, +)
        let totalString = String(total)
        
        let finalString = "$ \(totalString)"
        return finalString
    }
    /// Function to return the total fav items out of an array of items.
    func totalFavs(array: [Item]) -> String {
        let favItems = array.filter { $0.isFavourite }
        return String(favItems.count)
    }
    /// Function to return the total regret items out of an array of items.
    func totalRegrets(array: [Item]) -> String {
        let regretItems = array.filter { $0.isRegret }
        return String(regretItems.count)
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
    //MARK: PDF Export Functions
    func itemCount(array: [Item]) -> String {
        let count = array.count
        return String(count)
    }
    func weightCount(array: [Item]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(totalGrams(array: array)) g"
        } else {
            let lbOz = totalLbsOz(array: array)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            value = "\(lb) lb \(oz) oz"
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
            let oz = item.itemOZ
            value = "\(lbs) Lbs \(oz) Oz"
        }
        return value
    }
    //MARK: Text Formatting/ Logic Functions
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
            return "$ \(itemPriceText); "
        } else if !itemWeightText.isEmpty && !itemPriceText.isEmpty {
            return "\(itemWeightText) | $ \(itemPriceText); "
        } else {
            return ""
        }
    }
    //MARK: Create New HTML String and PDF
    func createHTML(pdfInt: Int) -> String {
        var shelves = [String]()
        var brands = [String]()
        self.sheds.forEach { shed in
            shelves.append(shed.name)
        }
        self.brands.forEach { brand in
            brands.append(brand.name)
        }
        func pdfType() -> String {
            var text: String = ""
            if pdfInt == 0 {
                text = "Shelf View"
            } else if pdfInt == 1 {
                text = "Brand View"
            } else if pdfInt == 2 {
                text = "Wishlist View"
            } else if pdfInt == 3 {
                text = "Favorite View"
            } else if pdfInt == 4 {
                text = "Regret View"
            }
            return text
        }
        func pdfDate() -> String {
            var text: String = ""
            text = Date().monthDayYearDateText()
            return text
        }
        func pdfStats() -> String {
            if pdfInt == 0 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(shelves.count)</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(totalCost(array: items))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 1 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Brands</p>
                            <p class="statVal">\(brands.count)</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(totalCost(array: items))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 2 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: wishListItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: wishListItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Cost</p>
                            <p class="statVal">\(totalCost(array: wishListItems))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 3 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: favItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: favItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(totalCost(array: favItems))</p>
                        </div>
                        <!--
                        """
            } else if pdfInt == 4 {
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: regretItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: regretItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(totalCost(array: regretItems))</p>
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
                for shelf in shelves {
                    let items = items.filter { $0.shedName == shelf }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf) | \(weightCount(array: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 1 {
                for brand in brands {
                    let items = items.filter { $0.brandName == brand }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(brand) | \(weightCount(array: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 2 {
                for shelf in shelves {
                    let items = wishListItems.filter { $0.shedName == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf) | \(weightCount(array: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 3 {
                for shelf in shelves {
                    let items = favItems.filter { $0.shedName == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf) | \(weightCount(array: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            } else if pdfInt == 4 {
                for shelf in shelves {
                    let items = regretItems.filter { $0.shedName == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf) | \(weightCount(array: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
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
        guard let htmlFile = Bundle.main.url(forResource: "gearShedTemplate", withExtension: "html")
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
            .replacingOccurrences(of: "#PDF_TYPE#", with: pdfType())
            .replacingOccurrences(of: "#DATE#", with: pdfDate())
            .replacingOccurrences(of: "{{IMG_SRC}}", with: imageURL.description)
            .replacingOccurrences(of: "#STAT_BAR#", with: pdfStats())
            .replacingOccurrences(of: "#ITEM_SECTION#", with: pdfItemSections())
        return finalHTML
    }
    func printPDF(pdfInt: Int) {
        let printController = UIPrintInteractionController.shared
        let printFormatter = UIMarkupTextPrintFormatter(markupText: createHTML(pdfInt: pdfInt))
        printController.printFormatter = printFormatter
        printController.present(animated: true) { (controller, completion, error) in
            print(error ?? "Print controller presented.")
        }
    }
}
