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
    @State private var editableGearlistData: EditableGearlistData
    
    var gearlist: Gearlist?
    
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
            listNameFeild
            itemList
        }
        .navigationBarTitle("New List", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableGearlistData.canGearlistBeSaved) }
        }
        .onDisappear { PersistentStore.shared.saveContext() }
    }
    
}

extension AddListView {
    
    private var listNameFeild: some View {
        HStack {
            Text("List Name: ")
            TextField("List Name", text: $editableGearlistData.gearlistName)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var itemList: some View {
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
    
    private func cancelButton() -> some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Text("Cancel")
        }
    }
    
    private func saveButton() -> some View {
        Button(action: commitData) {
            Text("Save")
        }
    }
    
    private func commitData() {
        presentationMode.wrappedValue.dismiss()
        if itemsChecked.count >= 1 {
            Gearlist.addNewGearlist(using: editableGearlistData, itemArray: itemsChecked)
        } else {
            Gearlist.updateData(using: editableGearlistData)
        }
    }
}










