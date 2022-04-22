//
//  AddPileItemView.swift
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
    private var pile: Pile?
    private var pack: Pack?
    private var type: SelectType
    private var itemOut: ((Item) -> ())?
    
    func availablePileItems() -> [Item] {
        var array = [Item]()
        for item in gearlist.items {
            if item.gearlistPile(gearlist: gearlist) == nil {
                array.append(item)
            }
        }
        return array
    }
    
    func availablePackItems() -> [Item] {
        var array = [Item]()
        for item in gearlist.items {
            if item.gearlistPack(gearlist: gearlist) == nil {
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
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from gearlist items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist) {
        self.type = type
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from pile items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pile: Pile) {
        self.type = type
        self.gearlist = gearlist
        self.pile = pile
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from pack items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pack: Pack) {
        self.type = type
        self.gearlist = gearlist
        self.pack = pack
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    /// Initializer for loading a Item Select view (All Shed Items) for selecting a single Item that gets returned with an @escaping function.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, itemOut: @escaping ((Item) -> ())) {
        self.type = type
        self.itemOut = itemOut
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
}

extension AddItemsToGearListView {
    // MARK: Content
    
    private var itemList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                switch type {
                case .gearlistItem:
                    if itemVM.items.count == 0 {
                        EmptyViewText(text: "You have no gear to add to this list. Get started by going back to the 'Gear Shed' tab to add your gear.")
                    } else {
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
                                ZStack {
                                    Color.theme.headerBG
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 25)
                                    HStack {
                                        Text(section.title)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 15)
                                }
                            }
                        }
                    }
                case .pileItem:
                    if availablePileItems().count == 0 {
                        EmptyViewText(text: "There is no more gear you can add to this pile. Either add more gear to this list or move gear out of another pile, so you can add it to this one.")
                    } else {
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
                                ZStack {
                                    Color.theme.headerBG
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 25)
                                    HStack {
                                        Text(section.title)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 15)
                                }
                            }
                        }
                    }
                case .packItem:
                    if availablePackItems().count == 0 {
                        EmptyViewText(text: "There is no more gear you can add to this pack. Either add more gear to this list or move gear out of another pack, so you can add it to this one.")
                    } else {
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
                                ZStack {
                                    Color.theme.headerBG
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 25)
                                    HStack {
                                        Text(section.title)
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 15)
                                }
                            }
                        }
                    }
                    
                }
            }
            //.padding(.bottom, 100)
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
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Select Gear")
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
                        detailManager.secondaryTarget = .noView
                    }
                case .pileItem:
                    viewModel.updatePileItems(addingItems: itemsChecked, removingItems: itemsUnChecked, pile: pile!)
                    withAnimation {
                        detailManager.secondaryTarget = .noView
                    }
                case .packItem:
                    viewModel.updatePackItems(addingItems: itemsChecked, removingItems: itemsUnChecked, pack: pack!)
                    withAnimation {
                        detailManager.secondaryTarget = .noView
                    }
                }
            } label: {
                Text("Save")
            }
            .disabled(!canSave)
        }
    }
}


/*VStack {
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
}*/
