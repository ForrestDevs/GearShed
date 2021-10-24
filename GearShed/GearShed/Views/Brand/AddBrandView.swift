//
//  AddOrModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// MARK: - View Definition

struct AddBrandView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    var brand: Brand?
    
    // custom init to set up editable data
    init(brand: Brand? = nil) {
        _editableData = State(initialValue: EditableItemData(brand: brand))
        self.brand = brand
    }

    var body: some View {
            Form {
                // 1: Name
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Brand name", text: $editableData.brandName)
                    }
                    

                } // end of Section 1
                
                // Section 2: Delete button, if present (must be editing a user brand)
                if editableData.representsExistingBrand && !editableData.associatedBrand.isUnknownBrand {
                    Section(header: Text("Brand Management").sectionHeader()) {
                        SLCenteredButton(title: "Delete This Brand",
                                         action: { viewModel.confirmDeleteBrandAlert = ConfirmDeleteBrandAlert(
                                        brand: editableData.associatedBrand,
                                        destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                        )
                        .foregroundColor(Color.red)
                    }
                }
                
                // Section 3: Items assigned to this Brand, if we are editing a Brand
                //if editableData.representsExistingBrand {
                //    SimpleItemsListForBrand(brand: editableData.associatedBrand/*,
                //                                    isAddNewItemSheetShowing: $isAddNewItemSheetShowing*/)
                //}
                
            } // end of Form
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Add New Brand", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canBrandBeSaved) }
            }
            .alert(item: $viewModel.confirmDeleteBrandAlert) { item in item.alert() }
       
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

    func commitData() {
        presentationMode.wrappedValue.dismiss()
        Brand.updateData(using: editableData)
    }
    
}


struct SimpleItemsListForBrand: View {
    
    @FetchRequest    private var items: FetchedResults<Item>
    
    @State private var listDisplayID = UUID()
    //@Binding var isAddNewItemSheetShowing: Bool
    
    init(brand: Brand/*, isAddNewItemSheetShowing: Binding<Bool>*/) {
        let request = Item.allItemsFR(at: brand)
        _items = FetchRequest(fetchRequest: request)
        //_isAddNewItemSheetShowing = isAddNewItemSheetShowing
    }
    
    var body: some View {
        Section(header: ItemsListHeader()) {
            ForEach(items) { item in
                NavigationLink(destination: AddItemView(editableItem: item)) {
                    Text(item.name)
                }
            }
        }
//        .id(listDisplayID)
        .onAppear { listDisplayID = UUID() }
    }
    
    func ItemsListHeader() -> some View {
        HStack {
            Text("At this Brand: \(items.count) items").sectionHeader()
            Spacer()
            
           //Button {
           //    isAddNewItemSheetShowing = true
           //} label: {
           //    Image(systemName: "plus")
           //        .font(.title2)
           //}
        }
    }
}
