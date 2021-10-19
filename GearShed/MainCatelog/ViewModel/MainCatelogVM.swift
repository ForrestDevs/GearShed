//
//  MainCatelogViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-16.
//

import Foundation
import SwiftUI
import CoreData

final class MainCatelogVM: ObservableObject {
    
    // Array that is initialized with all Items whenever the ViewModel is called
    @Published var allItems: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var itemInCategory: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var itemInBrand: [Item] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allCategories: [Category] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allBrands: [Brand] = []
    
    // Array that is initialized with all Categories whenever the ViewModel is called
    @Published var allTags: [Tag] = []
    
    // Local state to trigger showing a sheet to add a new item in MainCatelog
    @Published var isAddNewItemSheetShowing = false
    
    @Published var expandedCategory = false
    @Published var expandedBrand = false
    @Published var expandedTag = false
    
    // Local state for if we are a multi-section display or not.  the default here is false,
    // but an eager developer could easily store this default value in UserDefaults (?)
    //@Published var multiSectionDisplay: Bool = true
    
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
    @Published var confirmDeleteTagAlert: ConfirmDeleteTagAlert?
    
    // Local state to hold Search Text Value in Main Catelog
    @Published var searchText: String = ""

    init () {
        getItems(onList: true)
        getCategories()
        getBrands()
        getTags()
    }
    
    func getItems(onList: Bool) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "onList_ == %d", onList)
        request.predicate = filter
        
        do {
            allItems = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        do {
            allCategories = try PersistentStore.shared.context.fetch(request)
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
    
    func getCategoryItems(category: Category) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "category_ == %@", category)
        request.predicate = filter
        
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
    class func allCategorysFR(onList: Bool = false) -> NSFetchRequest<Category> {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        if onList {
            request.predicate = NSPredicate(format: "ANY items_.onList_ == true")
        }
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
            Button {self.isAddNewItemSheetShowing.toggle()}
                label: { Text("Add Gear")
                        .font(.title2)
                        .italic()
                        .foregroundColor(Color.theme.green)
                }
        }
        
    }
        
    // a toggle button to share gear list
    func leadingButton() -> some View {
        Button() { self.showDisplayAction.toggle() }
        label: { Image(systemName: "square.and.arrow.up")
                .font(.title2)
        }
    }
    
}
