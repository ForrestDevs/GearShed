//
//  AddItemsToGearListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

enum SelectType {
    case gearlistItem, pileItem, packItem, onBody, baseWeight, consumable
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
    //MARK: Available Item Functions
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
    func availableOBCItems(type: OBCType) -> [Item] {
        var array = [Item]()
        
        for item in gearlist.items {
            switch type {
            case .onBody:
                if item.gearlistBaseWeight(gearlist: gearlist) == nil && item.gearlistConsumable(gearlist: gearlist) == nil {
                    array.append(item)
                }
//                if item.gearlistOnBody(gearlist: gearlist) == nil {
//                    array.append(item)
//                }
            case .baseWeight:
                if item.gearlistOnBody(gearlist: gearlist) == nil && item.gearlistConsumable(gearlist: gearlist) == nil {
                    array.append(item)
                }
//                if item.gearlistBaseWeight(gearlist: gearlist) == nil {
//                    array.append(item)
//                }
            case .consumable:
                if item.gearlistBaseWeight(gearlist: gearlist) == nil && item.gearlistOnBody(gearlist: gearlist) == nil {
                    array.append(item)
                }
//                if item.gearlistConsumable(gearlist: gearlist) == nil {
//                    array.append(item)
//                }
            }
        }
        return array
    }
}

extension AddItemsToGearListView {
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from gearlist items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        self.type = type
        self.gearlist = gearlist
    }
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from pile items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pile: Pile) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        self.type = type
        self.gearlist = gearlist
        self.pile = pile
    }
    /// Initializer for loading a Item Select view (All Shed Items) for addition/ subtraction from pack items.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, pack: Pack) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        self.type = type
        self.gearlist = gearlist
        self.pack = pack
    }
    /// Initializer for loading a Item Select view (All Shed Items) for selecting a single Item that gets returned with an @escaping function.
    init(persistentStore: PersistentStore, type: SelectType, gearlist: Gearlist, itemOut: @escaping ((Item) -> ())) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        self.type = type
        self.itemOut = itemOut
        self.gearlist = gearlist
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
                case .onBody:
                    if availableOBCItems(type: .onBody).count == 0 {
                        EmptyViewText(text: "There is no more gear you can add to On Body. Either add more gear to this list or move gear out of another OBC, so you can add it to this one.")
                    } else {
                        ForEach(itemVM.sectionByShed(itemArray: availableOBCItems(type: .onBody))) { section in
                            Section {
                                ForEach(section.items) { item in
                                    SelectableItemRowView (
                                        type: .onBody,
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
                case .baseWeight:
                    if availableOBCItems(type: .baseWeight).count == 0 {
                        EmptyViewText(text: "There is no more gear you can add to Base Weight. Either add more gear to this list or move gear out of another OBC, so you can add it to this one.")
                    } else {
                        ForEach(itemVM.sectionByShed(itemArray: availableOBCItems(type: .baseWeight))) { section in
                            Section {
                                ForEach(section.items) { item in
                                    SelectableItemRowView (
                                        type: .baseWeight,
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
                case .consumable:
                    if availableOBCItems(type: .consumable).count == 0 {
                        EmptyViewText(text: "There is no more gear you can add to Consumables. Either add more gear to this list or move gear out of another OBC, so you can add it to this one.")
                    } else {
                        ForEach(itemVM.sectionByShed(itemArray: availableOBCItems(type: .consumable))) { section in
                            Section {
                                ForEach(section.items) { item in
                                    SelectableItemRowView (
                                        type: .consumable,
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
                    viewModel.updatePackItems(addingItems: itemsChecked, removingItems: itemsUnChecked, pack: pack!, gearlist: gearlist)
                    withAnimation {
                        detailManager.secondaryTarget = .noView
                    }
                case .onBody:
                    viewModel.updateOBCItems(gearlist: gearlist, addingItems: itemsChecked, removingItems: itemsUnChecked, type: .onBody)
                    withAnimation {
                        detailManager.secondaryTarget = .noView
                    }
                case .baseWeight:
                    viewModel.updateOBCItems(gearlist: gearlist, addingItems: itemsChecked, removingItems: itemsUnChecked, type: .baseWeight)
                    withAnimation {
                        detailManager.secondaryTarget = .noView
                    }
                case .consumable:
                    viewModel.updateOBCItems(gearlist: gearlist, addingItems: itemsChecked, removingItems: itemsUnChecked, type: .consumable)
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

