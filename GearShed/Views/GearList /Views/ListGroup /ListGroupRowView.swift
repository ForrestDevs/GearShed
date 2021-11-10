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
    }
}

extension ListGroupRowView {
    
    private var listGroupHeader: some View {
        VStack {
            HStack {
                TextField("", text: $editableData.name.onChange(updateListGroupName))
                Button {
                    addItemsToListGroup.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    viewModel.deleteListGroup(listGroup: listGroup, gearlist: gearlist)
                } label: {
                    Image(systemName: "trash")
                }
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    func updateListGroupName(to value: String) {
        viewModel.updateListGroup(using: editableData, listGroup: listGroup)
    }
    private var itemsList: some View {
        ForEach(listGroup.items) { item in
            ItemRowViewInListGroup(persistentStore: persistentStore, item: item, listGroup: listGroup, gearlist: gearlist)
        }
        .padding(.horizontal)
    }
    
}

struct ItemRowViewInListGroup: View {
    @Environment(\.presentationMode) private var presentationMode
        
    let persistentStore: PersistentStore
    
    let gearList: Gearlist
        
    let item: Item
    
    let listGroup: ListGroup
    
    @StateObject private var viewModel: GearlistData
    
    @State private var itemPackingGroup: PackingGroup?
    @State private var oldItemPackingGroup: PackingGroup?
    
    @State private var editableData: EditableItemDataInList
            
    @State private var addNewPackingGroup: Bool = false
    @State private var confirmRemoveItemAlert: ConfirmRemoveItemFromListAlert?

    init(persistentStore: PersistentStore, item: Item, listGroup: ListGroup, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.item = item
        self.gearList = gearlist
        self.listGroup = listGroup
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemDataInList(persistentStore: persistentStore, item: item, listGroup: listGroup, gearlist: gearlist)
        _editableData = State(initialValue: initialValue)
        
        let initialItemPG = item.listGroupPackingGroup(gearlist: gearlist, listGroup: listGroup)
        _itemPackingGroup = State(initialValue: initialItemPG)
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
                packGroupOut: { packGroup in
                    editableData.packingGroup = packGroup
                    viewModel.updateItemPackingGroup(using: editableData)
                }
            )
        }
    }
}

extension ItemRowViewInListGroup {
        
    private var itemBody: some View {
        ZStack {
            Color.clear
            HStack {
                HStack {
                    Text(item.brandName)
                        .foregroundColor(Color.theme.accent)
                    Text("|")
                    Text(item.name)
                        .foregroundColor(Color.theme.green)
                }
                packingGroupMenu
            }
        }
        .contextMenu {
            deleteContextButton
        }
        .alert(item: $confirmRemoveItemAlert) { item in item.alert() }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmRemoveItemAlert = ConfirmRemoveItemFromListAlert (
                persistentStore: persistentStore,
                item: item,
                listGroup: listGroup,
                packingGroup: editableData.packingGroup,
                destructiveCompletion: { presentationMode.wrappedValue.dismiss() }
            )
        } label: {
            HStack {
                Text("Remove Item From List")
                Image(systemName: "trash")
            }
        }
    }
    
    private var packingGroupMenu: some View {
        Menu {
            addNewPackingGroupButton
            packingGroupMenuList
        } label: {
            packingGroupMenuLabel
        }
    }
    
    private var packingGroupMenuList: some View {
        ForEach(viewModel.gearlistPackingGroups(gearlist: gearList)) { packingGroup in
            Button {
                editableData.packingGroup = packingGroup
                viewModel.updateItemPackingGroup(using: editableData)
            } label: {
                Text(packingGroup.name)
                    .font(.subheadline)
            }
            /*.onChange(of: itemPackingGroup) { newValue in
                viewModel.updateItemPackingGroup(item: item, packingGroup: itemPackingGroup!, previousPackingGroup: oldItemPackingGroup!)
            }*/
        }
    }
    
    private var packingGroupMenuLabel: some View {
        HStack {
            Text(editableData.packingGroup?.name ?? "Select PackGroup")
                .font(.subheadline)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(8)
    }
    
    private var addNewPackingGroupButton: some View {
        Button {
            addNewPackingGroup.toggle()
        } label: {
            Text("Add New PackIn")
            .font(.subheadline)
        }
    }
    
}


extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct LukeView: View {
    @State private var name = ""

    var body: some View {
        TextField("Enter your name:", text: $name.onChange(nameChanged))
            .textFieldStyle(.roundedBorder)
    }

    func nameChanged(to value: String) {
        print("Name changed to \(name)!")
    }
}
