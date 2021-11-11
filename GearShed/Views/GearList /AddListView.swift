//
//  AddListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddListView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var viewModel: GearlistData
    
    let persistentStore: PersistentStore
    
    @State private var editableData: EditableGearlistData
    
    @State private var isTrip: Bool = false
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                contentLayer
            }
            .navigationBarTitle("Add List", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension AddListView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showAddNewGearlist = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let newGearList = viewModel.addNewGearlist(using: editableData)
                withAnimation {
                    detailManager.showAddNewGearlist = false
                    detailManager.content = AnyView (
                        AddItemsToGearListView(persistentStore: persistentStore, gearlist: newGearList)
                            .environmentObject(detailManager)
                            .environmentObject(viewModel)
                    )
                    detailManager.showSelectGearlistItems = true
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
    
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var contentLayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                listNameSection
                listDescriptionSection
                tripSection
            }
            .padding()
        }
    }
    
    private var listNameSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var listDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()

                TextField("", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
            }
        }
    }

    private var tripSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Toggle(isOn: $isTrip) {
                    Text("Is Trip List?")
                }
                if isTrip {
                    Text("Trip Length")
                    Text("Trip Location")
                    Text("")
                }
            }
        }
        
    }
    
}

/*VStack {
    listNameFeild
    addItemGroupButton
    listGroupItemsList
    //itemList
}*/

/*private var listNameFeild: some View {
    HStack {
        Text("List Name: ")
        TextField("List Name", text: $editableData.name)
    }
    .padding(.horizontal, 20)
    .padding(.top, 10)
}



private var listGroupItemsList: some View {
    ScrollView (.vertical, showsIndicators: false) {
        ForEach(gearlist.listGroups) { listGroup in
            ClusterRowView(persistentStore: persistentStore, listGroup: listGroup, gearlist: gearlist)
        }
    }
}*/

/*private var itemList: some View {
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
}*/

// The purpose of this function is to add the selected
// item to our temporary array itemsChecked
/*private func handleItemSelected(_ item: Item) {
    if !itemsChecked.contains(item) {
        itemsChecked.append(item)
    }
}*/

// The purpose of this function is to remove the selected item
// from our temporary array itemsChecked, if the user unselects an item
/*private func handleItemUnSelected(_ item: Item) {
    self.itemsChecked.removeAll{$0.id == item.id}
}*/









