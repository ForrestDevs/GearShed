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
        
    @StateObject private var itemVM: GearShedData
    @StateObject private var listVM: GearlistData

    @ObservedObject private var listGroup: ListGroup
    
    @State private var addItemsToListGroup: Bool = false
    
    init(persistentStore: PersistentStore, listGroup: ListGroup, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.listGroup = listGroup
        self.gearlist = gearlist
        // Init viewModel
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        
        // Gearlist VM
        let listVM = GearlistData(persistentStore: persistentStore)
        _listVM = StateObject(wrappedValue: listVM)
    }
    
    var body: some View {
        VStack {
            // Header
            VStack {
                HStack {
                    TextField("", text: $listGroup.name)

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
            // Item List
            ForEach(listGroup.items) { item in
                ItemRowViewInList(persistentStore: persistentStore, item: item, gearlist: gearlist)
            }
            .padding(.horizontal)
        }
        .padding()
        .fullScreenCover(isPresented: $addItemsToListGroup) {
            AddListGroupItemView(persistentStore: persistentStore, listGroup: listGroup)
        }
    }
}

struct ItemRowViewInList: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: GearlistData

    let persistentStore: PersistentStore
    
    let gearList: Gearlist
        
    @ObservedObject var item: Item
    
    @State private var editableData: EditablePackingGroupData
    
    @State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    @State private var showDetail: Bool = false
    @State private var showEdit: Bool = false
    
    @State private var addNewPackingGroupNavLinkActive: Bool = false

    
    var body: some View {
        ZStack {
            Color.clear
            
            itemBody
            
            
        }
        .contextMenu {
            deleteContextButton
        }
        .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
    }
}

extension ItemRowViewInList {
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteItemAlert = ConfirmDeleteItemAlert (
                persistentStore: persistentStore,
                item: item,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Item")
                Image(systemName: "trash")
            }
        }
    }
    
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
            // Add New Packing Group Button
            Button {
                addNewPackingGroupNavLinkActive.toggle()
            } label: {
                Text("Add New PackIn")
                .font(.subheadline)
            }
            
            // List Of Current Sheds
            ForEach(viewModel.gearlistPackingGroups(gearlist: gearList)) { packingGroup in
                Button {
                    editableData.packingGroup = packingGroup
                } label: {
                    Text(packingGroup.name)
                        .tag(packingGroup)
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
        .background(
            NavigationLink(
                destination: AddPackingGroupView (
                                persistentStore: persistentStore,
                                packGroupOut: { packGroup in editableData.packingGroup = packGroup }),
                isActive: $addNewPackingGroupNavLinkActive) {
                EmptyView()
            }
        )
        
        /*Menu {
            ForEach(1..<5) { item in
                Text("item \(item) ")
            }
        } label: {
             Text("Packed In")
                .background(Color.blue)
        }*/
        
        
    }
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.item = item
        self.gearList = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditablePackingGroupData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
    }
    
}
