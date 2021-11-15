//
//  AddClusterItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import SwiftUI

struct AddItemsToGearListView: View {
        
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @StateObject private var itemVM: GearShedData

    @State private var itemsChecked: [Item] = []
    
    let gearlist: Gearlist
    
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
        self.persistentStore = persistentStore
        
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                itemList
            }
            .navigationBarTitle("Select Items", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension AddItemsToGearListView {
    // MARK: Content
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
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
            }
        }
        //.padding(.top, 5)
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
                withAnimation {
                    detailManager.showSelectGearlistItems = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.addItemsToGearlist(gearlist: gearlist, itemArray: itemsChecked)
                withAnimation {
                    detailManager.content = AnyView (
                        GearlistDetailView(gearlist: gearlist)
                            .environmentObject(detailManager)
                            .environmentObject(persistentStore)
                            .environmentObject(viewModel)
                    )
                    detailManager.showGearlistDetail = true
                    detailManager.showSelectGearlistItems = false
                }
            } label: {
                Text("Save")
            }
            .disabled(itemsChecked.count == 0)
        }
    }
}
 

