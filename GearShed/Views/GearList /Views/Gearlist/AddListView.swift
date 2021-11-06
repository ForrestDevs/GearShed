//
//  AddListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var itemVM: GearShedData
    @StateObject private var listVM: GearlistData

    @State private var itemsChecked: [Item] = []
    @State private var editableGearlistData: EditableGearlistData
    
    @ObservedObject private var gearlist: Gearlist
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        
        self.gearlist = gearlist
        
        // Init viewModel
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        
        // Gearlist VM
        let listVM = GearlistData(persistentStore: persistentStore)
        _listVM = StateObject(wrappedValue: listVM)
        
        // Init EditableGearlistData
        _editableGearlistData = State(initialValue: EditableGearlistData(persistentStore: persistentStore, gearlist: gearlist))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                listNameFeild
                addItemGroupButton
                listGroupItemsList
                //itemList
            }
            .navigationBarTitle("New List", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
    }
}

extension AddListView {
    
    private var listNameFeild: some View {
        HStack {
            Text("List Name: ")
            TextField("List Name", text: $editableGearlistData.name)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var addItemGroupButton: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                listVM.createNewListGroup(gearlist: gearlist)
            } label: {
                Text("Add Item Group")
            }
        }
    }
    
    private var listGroupItemsList: some View {
        ScrollView (.vertical, showsIndicators: false) {
            ForEach(gearlist.listGroups) { listGroup in
                ListGroupRowView(persistentStore: persistentStore, listGroup: listGroup, gearlist: gearlist)
            }
        }
    }
    
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(itemVM.sectionByShed(itemArray: itemVM.items)) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowViewForList(item: item, respondToTapOnSelector: {
                            handleItemSelected(item)
                        }, respondToTapOffSelector: {
                            handleItemUnSelected(item)
                        })
                        .padding(.horizontal, 15)
                        .padding(.bottom, 5)
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
            .padding(.top,10)
        }
    }
    
    // The purpose of this function is to add the selected
    // item to our temporary array itemsChecked
    private func handleItemSelected(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
    }
    
    // The purpose of this function is to remove the selected item
    // from our temporary array itemsChecked, if the user unselects an item
    private func handleItemUnSelected(_ item: Item) {
        self.itemsChecked.removeAll{$0.id == item.id}
    }
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                persistentStore.context.delete(gearlist)
                presentationMode.wrappedValue.dismiss()
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                listVM.updateGearlist(using: editableGearlistData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableGearlistData.canGearlistBeSaved)
        }
    }
    
    
}










