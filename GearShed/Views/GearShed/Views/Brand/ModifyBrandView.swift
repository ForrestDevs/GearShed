//
//  ModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    @State private var editableData: EditableItemData
    
    var brand: Brand?
    
    init(brand: Brand? = nil) {
        _editableData = State(initialValue: EditableItemData(brand: brand))
        self.brand = brand
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Brand name", text: $editableData.brandName)
                            .disableAutocorrection(true)
                    }
                }
                
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
            }
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
    
    private func deleteAndDismiss(_ brand: Brand) {
        Brand.delete(brand)
        presentationMode.wrappedValue.dismiss()
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
        presentationMode.wrappedValue.dismiss()
        Brand.updateData(using: editableData)
    }
    
}


