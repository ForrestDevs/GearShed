//
//  ModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-22.
//

import SwiftUI

struct ModifyItemView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    // Environment state to dismiss page
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: MainCatelogVM
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    
    @State private var expandedShed: Bool = false
    
    @State private var expandedBrand: Bool = false
    
    // this editableData struct contains all of the fields of an Item that
    // can be edited here, so that we're not doing a "live edit" on the Item.
    @State private var editableItemData: EditableItemData
    
    // custom init here to set up editableData state
    init(persistentStore: PersistentStore, editableItem: Item? = nil, initialItemName: String? = nil, initialItemDetails: String? = nil, shed: Shed? = nil, brand: Brand? = nil) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        // initialize the editableData struct for the incoming item, if any; and
        // also carry in whatever might be a suggested Item name for a new Item
        if let item = editableItem {
            _editableItemData = State(initialValue: EditableItemData(item: item))
        } else {
            // here's we'll see if a suggested name for adding a new item was supplied
            let initialValue = EditableItemData(initialItemName: initialItemName, initialItemDetails: initialItemDetails, shed: shed,  brand: brand)
            _editableItemData = State(initialValue: initialValue)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 20) {
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Item Name:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        TextField(editableItemData.name, text: $editableItemData.name)
                            .textFieldStyle(.roundedBorder)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 2)
                            .foregroundColor(Color.theme.green)
                    }
                    
                    VStack (alignment: .leading, spacing: 20) {
                        Text("Item Stats:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            VStack {
                                TextField(editableItemData.weight, text: $editableItemData.weight)
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: 1)
                                    .foregroundColor(Color.theme.green)
                            }
                            
                            VStack {
                                TextField(editableItemData.price, text: $editableItemData.price)
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: 1)
                                    .foregroundColor(Color.theme.green)
                            }
                        }
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Shed - Brand")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        HStack (alignment: .firstTextBaseline, spacing: 10) {
                            DisclosureGroup(editableItemData.shed.name, isExpanded: $expandedShed) {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: AddShedView()) {
                                        Text("Add New Shed")
                                            .font(.subheadline)
                                            //.foregroundColor(Color.theme.green)
                                    }
                                    ForEach(viewModel.sheds) { shed in
                                        Text(shed.name).tag(shed)
                                            .font(.subheadline)
                                            //.foregroundColor(Color.theme.secondaryText)
                                            .onTapGesture {
                                                editableItemData.shed = shed
                                                //altShedSelected = true
                                                //altShedName = shed.name
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    expandedShed.toggle()
                                                }
                                            }
                                    }
                                }
                            }
                            
                            DisclosureGroup(editableItemData.brand.name, isExpanded: $expandedBrand) {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: AddBrandView()) {
                                        Text("Add New Brand")
                                            .font(.subheadline)
                                            //.foregroundColor(Color.theme.secondaryText)
                                    }
                                    ForEach(viewModel.brands) { brand in
                                        Text(brand.name).tag(brand)
                                            .font(.subheadline)
                                            //.foregroundColor(Color.theme.secondaryText)
                                            .onTapGesture {
                                                editableItemData.brand = brand
                                                //altBrandSelected = true
                                                //altBrandName = brand.name
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    expandedBrand.toggle()
                                                    //altBrandSelected.toggle()
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    /*VStack (alignment: .leading, spacing: 10) {
                        Text("Quantity")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        Stepper(value: $editableItemData.quantity, in: 1...50) {
                            HStack {
                                Spacer()
                                Text("\(editableItemData.quantity)")
                                Spacer()
                            }
                        }
                    }*/
                    
                    Toggle(isOn: $editableItemData.wishlist) {
                        Text("Wishlist Item")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Item Details:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        ZStack {
                            if editableItemData.details.isEmpty == true {
                                Text("placeholder")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            TextEditor(text: $editableItemData.details)
                                .frame(maxHeight: .infinity)
                                .padding(.horizontal, -5)
                        }
                        .font(.body)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                    
                    // Item Management (Delete), if present
                    if editableItemData.representsExistingItem {
                        SLCenteredButton(title: "Delete This Item", action: { confirmDeleteItemAlert =
                            ConfirmDeleteItemAlert(item: editableItemData.associatedItem,
                                destructiveCompletion: { presentationMode.wrappedValue.dismiss() })
                        })
                            .foregroundColor(Color.red)
                    }
                }
                .padding()
                .navigationBarTitle("Modify Item", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { cancelButton() }
                    ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableItemData.canBeSaved) }
                }
                .onAppear {
                    logAppear(title: "AddOrModifyItemView")
                }
                .onDisappear {
                    logDisappear(title: "AddOrModifyItemView")
                    PersistentStore.shared.saveContext()
                }
                .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
            }
        }
    }
    
    // Cancel Button
    func cancelButton() -> some View {
        Button("Cancel",action: {presentationMode.wrappedValue.dismiss()})
    }
    
    // the save button
    func saveButton() -> some View {
        Button("Save", action: commitDataEntry)
    }
    
    // called when you tap the Save button.
    func commitDataEntry() {
        guard editableItemData.canBeSaved else { return }
        
        Item.updateData(using: editableItemData)
        
        presentationMode.wrappedValue.dismiss()
    }
}
