//
//  ModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyBrandView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
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
        NavigationView {
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
            } // end of Form
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Edit Brand", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canBrandBeSaved) }
            }
            .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
        }
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


