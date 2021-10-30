//
//  ModifyShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyShedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    @State private var editableData: EditableItemData
    
    var shed: Shed?
    
    // custom init to set up editable data
    init(shed: Shed? = nil) {
        _editableData = State(initialValue: EditableItemData(shed: shed))
        self.shed = shed
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Shed name", text: $editableData.shedName)
                            .disableAutocorrection(true)

                    }
                }
                
                // Section 2: Delete button, if present (must be editing a user shed)
                if editableData.representsExistingShed && !editableData.associatedShed.isUnknownShed {
                    Section(header: Text("Shed Management").sectionHeader()) {
                        SLCenteredButton(title: "Delete This Shed",
                                        action: { confirmDeleteShedAlert = ConfirmDeleteShedAlert(
                                        shed: editableData.associatedShed,
                                        destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                        )
                        .foregroundColor(Color.red)
                    }
                }
            }
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Edit Shed", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canShedBeSaved) }
            }
            .alert(item: $confirmDeleteShedAlert) { item in item.alert() }
        }
    }
    
    private func deleteAndDismiss(_ shed: Shed) {
        Shed.delete(shed)
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
        Shed.updateData(using: editableData)
    }
}
