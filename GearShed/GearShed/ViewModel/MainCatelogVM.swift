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
    
    private let categoriesController: NSFetchedResultsController<Category>
    @Published var categories = [Category]()
    
    private let brandsController: NSFetchedResultsController<Brand>
    @Published var brands = [Brand]()
    
    init(persistentStore: PersistentStore, isFavourited: Bool = true, onWishlist: Bool = true) {
        self.persistentStore = persistentStore
        
        // MARK: Item Fetch Requests
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        
        itemsController = NSFetchedResultsController(fetchRequest: itemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let favItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        favItemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        favItemRequest.predicate = NSPredicate(format: "isFavourite_ == %d", isFavourited)
        
        favItemsController = NSFetchedResultsController(fetchRequest: favItemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let wishlistItemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        wishlistItemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        wishlistItemRequest.predicate = NSPredicate(format: "onList_ == %d", onWishlist)
        
        wishlistItemsController = NSFetchedResultsController(fetchRequest: wishlistItemRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Category Fetch Requests
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        
        categoriesController = NSFetchedResultsController(fetchRequest: categoryRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // MARK: Brand Fetch Requests
        let brandRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        brandRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Brand.name, ascending: true)]
        
        brandsController = NSFetchedResultsController(fetchRequest: brandRequest, managedObjectContext: persistentStore.context, sectionNameKeyPath: nil, cacheName: nil)
        
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
        categories = categoriesController.fetchedObjects ?? []
    }
    
    // MARK: Old
    
    // Array that is initialized with all Items whenever the ViewModel is called
    @Published var allItemsInShed: [Item] = []
    
    // Array that is initialized with all Items whenever the ViewModel is called
    @Published var allItemsInWishList: [Item] = []
    
    // Array that is initialized with all Items whenever the ViewModel is called
    @Published var allFavItems: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var itemInCategory: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var itemInBrand: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allUserCategories: [Category] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allBrands: [Brand] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allTags: [Tag] = []
    
    // Local state to trigger showing a sheet to Unlock Pro IAP
    @Published var showingUnlockView = false
    
    // Local state to trigger showing a sheet to add a new item in MainCatelog
    @Published var isAddNewItemShowing = false
    
    // State to trigger wether the item is favourited or not
    @Published var isFavourited: Bool = false
    
    @Published var selectedCategory: Category? = nil
    
    // Local state to trigger showing a view to Edit Item
    @Published var isEditItemShowing = false
    
    // Local state to trigger showing a view to Edit Brand
    @Published var isEditBrandShowing = false
    
    // Local state to trigger showing a view to Edit Category
    @Published var isEditCategoryShowing = false
    
    @Published var expandedCategory = false
    
    @Published var expandedBrand = false
    
    @Published var expandedTag = false
    
    // Local state for if we are a multi-section display or not.  the default here is false,
    // but an eager developer could easily store this default value in UserDefaults (?)
    @Published var showDisplayAction = false
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @Published var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @Published var confirmDeleteCategoryAlert: ConfirmDeleteCategoryAlert?
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    //@Published var confirmDeleteTagAlert: ConfirmDeleteTagAlert?
    
    // Local state to hold Search Text Value in Main Catelog
    @Published var searchText: String = ""

    /*init () {
        getItems(onList: false)
        getItems(onList: true)
        getFavItems()
        getUserCategories()
        getBrands()
        getTags()
    }*/
    
    func getItems(onList: Bool) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "onList_ == %d", onList)
        request.predicate = filter
        
        do {
            if onList == false {
                allItemsInShed = try PersistentStore.shared.context.fetch(request)
            } else {
                allItemsInWishList = try PersistentStore.shared.context.fetch(request)
            }
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getFavItems(isFavourite: Bool = true) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "isFavourite_ == %d", isFavourite)
        request.predicate = filter
        
        do {
            allFavItems = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getUserCategories(unknCategoryName: String = kUnknownCategoryName) {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "NOT name_ == %@", unknCategoryName)
        request.predicate = filter
        
        do {
            allUserCategories = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getBrands() {
        let request = NSFetchRequest<Brand>(entityName: "Brand")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        do {
            allBrands = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getTags() {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        do {
            allTags = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getCategoryItems(category: Category, onList: Bool = false) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let p1 = NSPredicate(format: "category_ == %@", category)
        let p2 = NSPredicate(format: "onList_ == %d", onList)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        
        do {
            itemInCategory = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getBrandItems(brand: Brand) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "brand_ == %@", brand)
        request.predicate = filter
        
        do {
            itemInBrand = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // MARK: - FetchRequests
    
    // a fetch request we can use in views to get all categorys, sorted by name.
    // by default, you get all categorys; setting onList = true returns only categorys that
    // have at least one of its shopping items currently on the shopping list
    class func allCategoriesFR(onList: Bool = false) -> NSFetchRequest<Category> {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        if onList {
            request.predicate = NSPredicate(format: "ANY items_.onList_ == true")
        }
        return request
    }
    
    class func allItemsInWishListFR(onList: Bool = true) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "onList_ == %d", onList)
        return request
    }
    
    class func allFavItemsFR(isFavourite: Bool = true) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "isFavourite_ == %d", isFavourite)
        return request
    }
    
    // a fetch request we can use in views to get all User categoriess, excluding the Unknown
    // category, sorted by name by default; setting onList = true returns only categorys that
    // have at least one of its item currently in the Gear Shed list
    class func allUserCategoriesFR(unknCategoryName: String = kUnknownCategoryName) -> NSFetchRequest<Category> {
        
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "NOT name_ == %@", unknCategoryName)
        request.predicate = filter
        
        return request
    }
    
    // a fetch request we can use in views to get all brands, sorted by name.
    // by default, you get all brands; setting onList = true returns only brands that
    // have at least one of its shopping items currently on the shopping list
    class func allBrandsFR(onList: Bool = false) -> NSFetchRequest<Brand> {
        let request: NSFetchRequest<Brand> = Brand.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        if onList {
            request.predicate = NSPredicate(format: "ANY items_.onList_ == true")
        }
        return request
    }
    
    // a fetch request we can use in views to get all User categoriess, excluding the Unknown
    // category, sorted by name by default; setting onList = true returns only categorys that
    // have at least one of its item currently in the Gear Shed list
    class func allUserBrandsFR(unknBrandName: String) -> NSFetchRequest<Brand> {
        
        let request = NSFetchRequest<Brand>(entityName: "Brand")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "NOT name_ == %@", unknBrandName)
        request.predicate = filter
        
        return request
    }
    
    // a fetch request we can use in views to get all brands, sorted by name.
    // by default, you get all brands; setting onList = true returns only brands that
    // have at least one of its shopping items currently on the shopping list
    class func allTagsFR() -> NSFetchRequest<Tag> {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
        
    // MARK: - ToolbarItems
    
    // Add New Button
    func trailingButtons() -> some View {
        HStack {
            Button {self.isAddNewItemShowing.toggle()} label: { Image(systemName: "plus") }
        }
    }
    
    func editBrandButton() -> some View {
        Button { self.isEditBrandShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
    }
    
    func editCategoryButton() -> some View {
        Button { self.isEditCategoryShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
    }
    
    func editItemButton() -> some View {
        Button { self.isEditItemShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
    }
    
    // a toggle button to share gear list
    func leadingButton() -> some View {
        Button() { [self] in
            self.showDisplayAction.toggle()
            writeAsJSON(items: Item.allItems(), to: kItemsFilename)
            writeAsJSON(items: allUserCategories, to: kCategorysFilename)
            writeAsJSON(items: Brand.allBrands(userBrandsOnly: true), to: kBrandsFilename)
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


