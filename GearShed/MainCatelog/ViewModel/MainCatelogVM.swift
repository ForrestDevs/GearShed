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
    @Published var itemsInCatelog: [Item] = []
    
    // Local state to trigger showing a sheet to add a new item in MainCatelog
    @Published var isAddNewItemSheetShowing = false
    
    // Local state for if we are a multi-section display or not.  the default here is false,
    // but an eager developer could easily store this default value in UserDefaults (?)
    @Published var multiSectionDisplay: Bool = true
    
    // Local state for if we are a multi-section display or not.  the default here is false,
    // but an eager developer could easily store this default value in UserDefaults (?)
    @Published var showDisplayAction = false
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    
    // Local state to hold Search Text Value in Main Catelog
    @Published var searchText: String = ""

    init () {
       getItems(onList: true)
    }
    
    func getItems(onList: Bool) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let sort = [NSSortDescriptor(key: "name_", ascending: true)]
        request.sortDescriptors = sort
        
        let filter = NSPredicate(format: "onList_ == %d", onList)
        request.predicate = filter
        
        do {
            itemsInCatelog = try PersistentStore.shared.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // MARK: Section Items List Based on Option
    

    
    // MARK: - ToolbarItems
    
    // Add New Button
    func trailingButtons() -> some View {
        
        HStack {
            // EDIT CATEGORIES
            NavigationLink(destination: CategoriesTabView()) {
                Text("Edit Categories")
                .foregroundColor(Color.blue)
                .padding(10)
            }
            //EDIT BRANDS
            NavigationLink(destination: BrandsTabView()) {
                Text("Edit Brands")
                .foregroundColor(Color.blue)
                .padding(10)
            }
            
            Button(action: { self.isAddNewItemSheetShowing.toggle() })
                { Image(systemName: "plus") .font(.title2) }
        }
        
    }
    
    // a toggle button to change section display mechanisms
    func sectionDisplayButton() -> some View {
        Button() { self.multiSectionDisplay.toggle() }
        label: { Image(systemName: multiSectionDisplay ? "tray.2" : "tray")
                .font(.title2)
        }
    }
    
    // a toggle button to change section display mechanisms
    func leadingButton() -> some View {
        Button() { self.showDisplayAction.toggle() }
        label: { Image(systemName: "list.bullet")
                .font(.title2)
        }
    }
    

    
    
    
    
}
