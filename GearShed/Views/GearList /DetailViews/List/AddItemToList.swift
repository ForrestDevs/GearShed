//
//  AddClusterItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import SwiftUI

struct AddItemsToGearListView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var viewModel: GearlistData
    @StateObject private var itemVM: GearShedData
    @State private var itemsChecked: [Item] = []
    @State private var itemsUnChecked: [Item] = []
    @State private var canSave: Bool = false
    private let gearlist: Gearlist
        
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    
    var body: some View {
        NavigationView {
            itemList
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButtonToolBarItem
                viewTitle
                saveButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension AddItemsToGearListView {
    // MARK: Content
    private var itemList: some View {
        VStack {
            List {
                ForEach(itemVM.sectionByShed(itemArray: itemVM.items)) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRowViewForList (
                                gearlist: gearlist,
                                item: item) {
                                    handleItemSelected(item)
                                } respondToTapOffSelector: {
                                    handleItemUnSelected(item)
                                }
                                .padding(.horizontal, 15)
                                .padding(.bottom, 5)
                        }
                    } header: {
                        HStack {
                            Text(section.title)
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Methods
    /// Function to add selected Item to temp array.
    private func handleItemSelected(_ item: Item) {
        canSave = true
        
        if gearlist.items.contains(item) {
            self.itemsUnChecked.removeAll{$0.id == item.id}
        }
        
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
        
    }
    /// Function to remove selected Item from temp array.
    private func handleItemUnSelected(_ item: Item) {
        canSave = true
        if gearlist.items.contains(item) {
            self.itemsUnChecked.append(item)
        }
        
        self.itemsChecked.removeAll{$0.id == item.id}
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showAddItemsToGearlist = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Select Items")
                .formatGreen()
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.updateGearlistItems(gearlist: gearlist, addingItems: itemsChecked, removingItems: itemsUnChecked)
                viewModel.addItemsToGearlist(gearlist: gearlist, itemArray: itemsChecked)
                detailManager.selectedGearlist = gearlist
                withAnimation {
                    detailManager.showAddItemsToGearlist = false
                    detailManager.showGearlistDetail = true
                }
            } label: {
                Text("Save")
            }
            .disabled(!canSave)
        }
    }
}

/*ScrollView(.vertical, showsIndicators: false) {
    LazyVStack {
        ForEach(itemVM.sectionByShed(itemArray: itemVM.items)) { section in
            Section {
                ForEach(section.items) { item in
                    ItemRowViewForList(item: item, respondToTapOnSelector: {
                        handleItemSelected(item)
                    }, respondToTapOffSelector: {
                        handleItemUnSelected(item)
                    })
                    
                }
            } header: {
                VStack (spacing: 0) {
                    HStack {
                        Text(section.title)
                            .font(.headline)
                        Spacer()
                    }
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }
                .padding(.horizontal)
            }
        }
    }
}*/
//.padding(.top, 5)
 

