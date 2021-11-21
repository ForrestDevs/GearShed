//
//  AddClusterItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import SwiftUI

enum SelectType {
    case gearlistItem, pileItem, packItem
}

struct AddItemsToGearListView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var viewModel: GearlistData
    @StateObject private var itemVM: GearShedData
    @State private var itemsChecked: [Item] = []
    @State private var itemsUnChecked: [Item] = []
    @State private var canSave: Bool = false
    
    private let gearlist: Gearlist
    private var pile: Cluster?
    private var pack: Container?
    
    private var type: SelectType
    
    func availablePileItems() -> [Item] {
        var array = [Item]()
        for item in gearlist.items {
            if item.gearlistCluster(gearlist: gearlist) == nil {
                array.append(item)
            }
        }
        return array
    }
    
    func availablePackItems() -> [Item] {
        var array = [Item]()
        for item in gearlist.items {
            if item.gearlistContainer(gearlist: gearlist) == nil {
                array.append(item)
            }
        }
        return array
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
    
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist) {
        self.type = type
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pile: Cluster) {
        self.type = type
        self.gearlist = gearlist
        self.pile = pile
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pack: Container) {
        self.type = type
        self.gearlist = gearlist
        self.pack = pack
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    
    
}

extension AddItemsToGearListView {
    // MARK: Content
    private var itemList: some View {
        VStack {
            List {
                switch type {
                case .gearlistItem:
                    ForEach(itemVM.sectionByShed(itemArray: itemVM.items)) { section in
                        Section {
                            ForEach(section.items) { item in
                                SelectableItemRowView (
                                    type: .gearlistItem,
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
                case .pileItem:
                    ForEach(itemVM.sectionByShed(itemArray: availablePileItems())) { section in
                        Section {
                            ForEach(section.items) { item in
                                SelectableItemRowView (
                                    type: .pileItem,
                                    pile: pile,
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
                case .packItem:
                    ForEach(itemVM.sectionByShed(itemArray: availablePackItems())) { section in
                        Section {
                            ForEach(section.items) { item in
                                SelectableItemRowView (
                                    type: .packItem,
                                    pack: pack,
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
    }
    
    // MARK: Methods
    /// Function to add selected Item to temp array.
    private func handleItemSelected(_ item: Item) {
        canSave = true
        
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
        
        if itemsUnChecked.contains(item) {
            itemsUnChecked.removeAll{$0.id == item.id}
        }
    }
    /// Function to remove selected Item from temp array.
    private func handleItemUnSelected(_ item: Item) {
        canSave = true
        
        if !itemsUnChecked.contains(item) {
            itemsUnChecked.append(item)
        }
        
        if itemsChecked.contains(item) {
            itemsChecked.removeAll{$0.id == item.id}
        }
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                switch type {
                case .gearlistItem:
                    withAnimation {
                        detailManager.showAddItemsToGearlist = false
                    }
                case .pileItem:
                    withAnimation {
                        detailManager.showAddItemsToCluster = false
                    }
                case .packItem:
                    withAnimation {
                        detailManager.showAddItemsToContainer = false
                    }
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
                switch type {
                case .gearlistItem:
                    viewModel.updateGearlistItems(gearlist: gearlist, addingItems: itemsChecked, removingItems: itemsUnChecked)
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.showAddItemsToGearlist = false
                        detailManager.showGearlistDetail = true
                    }
                case .pileItem:
                    viewModel.updateClusterItems(addingItems: itemsChecked, removingItems: itemsUnChecked, pile: pile!)
                    withAnimation {
                        detailManager.showAddItemsToCluster = false
                    }
                case .packItem:
                    viewModel.updateContainerItems(addingItems: itemsChecked, removingItems: itemsUnChecked, pack: pack!)
                    withAnimation {
                        detailManager.showAddItemsToContainer = false
                    }
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
 

