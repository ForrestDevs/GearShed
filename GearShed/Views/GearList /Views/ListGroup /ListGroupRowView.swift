//
//  ListGroupRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-04.
//

import SwiftUI

struct ListGroupRowView: View {

    let persistentStore: PersistentStore
    
    let gearlist: Gearlist
    
    let listGroup: ListGroup
        
    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditableListGroupData
    
    @State private var addItemsToListGroup: Bool = false
    
    init(persistentStore: PersistentStore, listGroup: ListGroup, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.listGroup = listGroup
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableListGroupData(persistentStore: persistentStore, listGroup: listGroup)
        _editableData = State(initialValue: initialValue)
    }
    
    var body: some View {
        VStack {
            listGroupHeader
            itemsList
        }
        .padding()
        .fullScreenCover(isPresented: $addItemsToListGroup) {
            AddListGroupItemView(persistentStore: persistentStore, listGroup: listGroup)
        }
        .onDisappear {
            viewModel.updateListGroup(using: editableData, listGroup: listGroup)
        }
    }
}

extension ListGroupRowView {
    
    private var listGroupHeader: some View {
        VStack {
            HStack {
                TextField("", text: $editableData.name)
                Button {
                    addItemsToListGroup.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    private var itemsList: some View {
        ForEach(listGroup.items) { item in
            ItemRowViewInListGroup(persistentStore: persistentStore, item: item, listGroup: listGroup, gearlist: gearlist)
        }
        .padding(.horizontal)
    }
    
}

struct ItemRowViewInListGroup: View {
        
    let persistentStore: PersistentStore
    
    let gearList: Gearlist
        
    let item: Item
    
    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditableItemDataInList
            
    @State private var addNewPackingGroup: Bool = false
    
    init(persistentStore: PersistentStore, item: Item, listGroup: ListGroup, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.item = item
        self.gearList = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemDataInList(persistentStore: persistentStore, item: item, listGroup: listGroup, gearlist: gearlist)
        _editableData = State(initialValue: initialValue)
    }

    var body: some View {
        ZStack {
            Color.clear
            itemBody
        }
        .fullScreenCover(isPresented: $addNewPackingGroup) {
            AddPackingGroupView (
                persistentStore: persistentStore,
                gearlist: gearList,
                packGroupOut: { packGroup in editableData.packingGroup = packGroup })
        }
        .onDisappear {
            viewModel.updateItemPackingGroup(using: editableData)
        }
    }
}

extension ItemRowViewInListGroup {
        
    private var itemBody: some View {
        HStack {
            HStack {
                Text(item.brandName)
                    .foregroundColor(Color.theme.accent)
                Text("|")
                Text(item.name)
                    .foregroundColor(Color.theme.green)
            }
            packInMenu
            Spacer()
        }
    }
    
    private var packInMenu: some View {
        Menu {
            Button {
                addNewPackingGroup.toggle()
            } label: {
                Text("Add New PackIn")
                .font(.subheadline)
            }
            
            ForEach(viewModel.gearlistPackingGroups(gearlist: gearList)) { packingGroup in
                Button {
                    editableData.packingGroup = packingGroup
                } label: {
                    Text(packingGroup.name)
                        .font(.subheadline)
                }
            }
        } label: {
            HStack {
                Text(editableData.packingGroup?.name ?? "Select PackGroup")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .padding(8)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
}
