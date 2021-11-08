//
//  AddListGroupItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import SwiftUI

struct AddListGroupItemView: View {
    @Environment(\.presentationMode) var presentationMode
        
    @StateObject private var itemVM: GearShedData
    @StateObject private var listVM: GearlistData

    @State private var itemsChecked: [Item] = []
    
    let listGroup: ListGroup
    
    init(persistentStore: PersistentStore, listGroup: ListGroup) {
        self.listGroup = listGroup
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        
        let listVM = GearlistData(persistentStore: persistentStore)
        _listVM = StateObject(wrappedValue: listVM)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                itemList
            }
            .navigationBarTitle("Add Items To Group", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
    }
}

extension AddListGroupItemView {
    // MARK: Content
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
    
    // MARK: Methods
    /// Function to add selected Item to temp array.
    private func handleItemSelected(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
    }
    /// Function to remove selected Item from temp array.
    private func handleItemUnSelected(_ item: Item) {
        self.itemsChecked.removeAll{$0.id == item.id}
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                listVM.addItemsToListGroup(listGroup: listGroup, itemArray: itemsChecked)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(itemsChecked.count == 0)
        }
    }
}

