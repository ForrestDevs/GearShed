//
//  MainCatelogViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

final class MainCatelogVM: NSObject, NSFetchedResultsControllerDelegate,  ObservableObject {
    
    let persistentStore: PersistentStore
    
    private let itemsController: NSFetchedResultsController<Item>
    @Published var items = [Item]()
    
    private let favItemsController: NSFetchedResultsController<Item>
    @Published var favItems = [Item]()
    
    private let wishlistItemsController: NSFetchedResultsController<Item>
    @Published var wishListItems = [Item]()
    
    let categoriesController: NSFetchedResultsController<Category>
    @Published var categories = [Category]()
    
    private let brandsController: NSFetchedResultsController<Brand>
    @Published var brands = [Brand]()
    
    init(persistentStore: PersistentStore,isFavourited: Bool = true, onWishlist: Bool = true) {
        self.persistentStore = persistentStore
        
        // MARK: Item Fetch Requests
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let favItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        favItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        favItemRequest.predicate = NSPredicate(format: "isFavourite_ == %d", isFavourited)
        
        favItemsController = NSFetchedResultsController(fetchRequest: favItemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let wishlistItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        wishlistItemRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        wishlistItemRequest.predicate = NSPredicate(format: "onList_ == %d", onWishlist)
        
        wishlistItemsController = NSFetchedResultsController(fetchRequest: wishlistItemRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Category Fetch Requests
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        categoriesController = NSFetchedResultsController(fetchRequest: categoryRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Brand Fetch Requests
        let brandRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        brandRequest.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        brandsController = NSFetchedResultsController(fetchRequest: brandRequest, managedObjectContext: PersistentStore.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Assign Entities to corosponding arrays
        super.init()
        itemsController.delegate = self
        favItemsController.delegate = self
        wishlistItemsController.delegate = self
        categoriesController.delegate = self
        brandsController.delegate = self
        
        do {
            try itemsController.performFetch()
            items = itemsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Items")
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
            try categoriesController.performFetch()
            categories = categoriesController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch Categories")
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
        wishListItems = wishlistItemsController.fetchedObjects ?? []
        categories = categoriesController.fetchedObjects ?? []
        brands = brandsController.fetchedObjects ?? []
    }
    
    // State to trigger wether the item is favourited or not
    @Published var isFavourited: Bool = false
    
    @Published var selectedCategory: Category? = nil
    
    // Local state to hold Search Text Value in Main Catelog
    @Published var searchText: String = ""
    
    @Published var isAddNewItemShowing: Bool = false
    
    @Published var showingUnlockView: Bool = false
     
    // MARK: - ToolbarItems
    
    func trailingButton() -> some View {
        Button {
            let canCreate = self.persistentStore.fullVersionUnlocked ||
                self.persistentStore.count(for: Item.fetchRequest()) < 3
            if canCreate {
                self.isAddNewItemShowing.toggle()
            } else {
                self.showingUnlockView.toggle()
            }
        } label: { Image(systemName: "plus") }
    }
    
    // a toggle button to share gear list
    func leadingButton() -> some View {
        Button { [self] in
            writeAsJSON(items: items, to: kItemsFilename)
            writeAsJSON(items: categories, to: kCategorysFilename)
            writeAsJSON(items: brands, to: kBrandsFilename)
        } label: {
            Image(systemName: "square.and.arrow.up")
                /*.fileExporter(isPresented: $showDisplayAction, documents: [kItemsFilename,kBrandsFilename,kCategorysFilename] , contentType: .json) { result in
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


