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
    
    @StateObject private var viewModel: GearShedData
    
    @State private var itemsChecked: [Item] = []
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableGearlistData: EditableGearlistData
    
    var gearlist: Gearlist?
    
    // custom init to set up editable trip and item data
    init(persistentStore: PersistentStore, gearlist: Gearlist? = nil, item: Item? = nil) {
        
        // Init viewModel
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        // Init EditableGearlistData
        _editableGearlistData = State(initialValue: EditableGearlistData(gearlist: gearlist))
        self.gearlist = gearlist
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("List Name: ")
                TextField("List Name", text: $editableGearlistData.gearlistName)
            }
            .padding(.horizontal, 20)
            
            itemList
                .padding(.top,10)
                .padding(.bottom, 50)
            
            Rectangle()
                .opacity(0)
                .frame(height: 50)
        }
        .navigationBarTitle("New List", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableGearlistData.canGearlistBeSaved) }
        }
        .onDisappear { PersistentStore.shared.saveContext() }
    }
    
    var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.sectionByShed(itemArray: viewModel.items)) { section in
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
        }
    }
    
    // The purpose of this function is to add the selected item to our temporary array itemsChecked
    func handleItemSelected(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
    }
    
    // The purpose of this function is to remove the selected item
    // from our temporary array itemsChecked, if the user unselects an item
    func handleItemUnSelected(_ item: Item) {
        self.itemsChecked.removeAll{$0.id == item.id}
    }

    func commitData() {
        presentationMode.wrappedValue.dismiss()
        if itemsChecked.count >= 1 {
            Gearlist.addNewGearlist(using: editableGearlistData, itemArray: itemsChecked)
        } else {
            Gearlist.updateData(using: editableGearlistData)
        }
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Text("Cancel")
        }
    }
    
    // the save button
    func saveButton() -> some View {
        Button(action: commitData) {
            Text("Save")
        }
    }
    
}










