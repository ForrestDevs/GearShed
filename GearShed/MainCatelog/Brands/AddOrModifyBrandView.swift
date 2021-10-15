//
//  AddOrModifyBrandView.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-09-30.
//  Copyright © 2021 Jerry. All rights reserved.
//

import SwiftUI

// MARK: - View Definition

struct AddOrModifyBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    var brand: Brand?
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    // trigger for adding a new item at this Brand
    //@State private var isAddNewItemSheetShowing = false
    
    // custom init to set up editable data
    init(brand: Brand? = nil) {
//        print("AddorModifyBrandView initialized")
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
                                    action: { confirmDeleteBrandAlert = ConfirmDeleteBrandAlert(
                                    brand: editableData.associatedBrand,
                                    destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                    )
                    .foregroundColor(Color.red)
                }
            }
            
            // Section 3: Items assigned to this Brand, if we are editing a Brand
            if editableData.representsExistingBrand {
                SimpleItemsListForBrand(brand: editableData.associatedBrand/*,
                                                isAddNewItemSheetShowing: $isAddNewItemSheetShowing*/)
            }
            
        } // end of Form
        .onDisappear { PersistentStore.shared.saveContext() }
        .navigationBarTitle(barTitle(), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canBrandBeSaved) }
        }
        .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
        /*.sheet(isPresented: $isAddNewItemSheetShowing) {
            NavigationView {
                AddOrModifyItemView()
                    .environment(\.managedObjectContext, PersistentStore.shared.context)
            }
        }*/

    }
    
    func barTitle() -> Text {
        return editableData.representsExistingBrand ? Text("Modify Brand") : Text("Add New Brand")
    }
    
    func deleteAndDismiss(_ brand: Brand) {
        Brand.delete(brand)
        presentationMode.wrappedValue.dismiss()
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
                NavigationLink(destination: AddOrModifyItemView(editableItem: item)) {
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
