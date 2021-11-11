//
//  AddMoreItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-26.
//

import SwiftUI

struct AddMoreItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var gearVM: GearlistData
    @StateObject private var itemVM: GearShedData
    
    @State private var itemsChecked: [Item] = []
    
    @ObservedObject private var gearlist: Gearlist
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
        
        let gearVM = GearlistData(persistentStore: persistentStore)
        _gearVM = StateObject(wrappedValue: gearVM)
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        
        gearVM.getItemsNotInList(gearlist: gearlist)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                itemsList
                    .padding(.top,10)
            }
            .navigationBarTitle("Add Items to \(gearlist.name)", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!canGearlistBeSaved) }
            }
        }
    }
    
}

extension AddMoreItemView {
    private var itemsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(itemVM.sectionByShed(itemArray: gearVM.itemsNotInList)) { section in
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
    
    private var canGearlistBeSaved: Bool { itemsChecked.count > 0 }
    
    // The purpose of this function is to add the selected item to our temporary array itemsChecked
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
        gearVM.addItemsToGearlist(gearlist: gearlist, itemArray: itemsChecked)
        presentationMode.wrappedValue.dismiss()
    }
}

