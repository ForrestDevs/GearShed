//
//  GearShedData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

final class GearShedData: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    let persistentStore: PersistentStore
    
    // State to trigger wether the item is favourited or not
    @Published var isFavourited: Bool = false
    
    // var to store a selctedShed to pre populate adding an item
    @Published var selectedShed: Shed? = nil
    
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
        
        itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let favItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        favItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        favItemRequest.predicate = NSPredicate(format: "isFavourite_ == %d", true)
        
        favItemsController = NSFetchedResultsController(fetchRequest: favItemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let regretItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        regretItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        regretItemRequest.predicate = NSPredicate(format: "isRegret_ == %d", true)
        
        regretItemsController = NSFetchedResultsController(fetchRequest: regretItemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let wishlistItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        wishlistItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        wishlistItemRequest.predicate = NSPredicate(format: "wishlist_ == %d", true)
        
        wishlistItemsController = NSFetchedResultsController(fetchRequest: wishlistItemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Shed Fetch Requests
        let shedRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
        shedRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        shedsController = NSFetchedResultsController(fetchRequest: shedRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Brand Fetch Requests
        let brandRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        brandRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        brandsController = NSFetchedResultsController(fetchRequest: brandRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
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
    
    // MARK: - ToolbarItems
    
    // a toggle button to share gear list
    func leadingButton() -> some View {
        Button { [self] in
            writeAsJSON(items: items, to: kItemsFilename)
            writeAsJSON(items: sheds, to: kShedsFilename)
            writeAsJSON(items: brands, to: kBrandsFilename)
        } label: {
            Image(systemName: "square.and.arrow.up")
                /*.fileExporter(isPresented: $showDisplayAction, documents: [kItemsFilename,kBrandsFilename,kShedsFilename] , contentType: .json) { result in
                    switch result {
                        case .success(let url):
                            print("Saved to \(url)")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                }*/
            
        }
    }
}


