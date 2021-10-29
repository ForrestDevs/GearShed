//
//  ModifyShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyShedView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
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
                // 1: Name, Colors
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Shed name", text: $editableData.shedName)
                            .disableAutocorrection(true)

                    }
                } // end of Section 1
                
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
                } // end of Section 2
            } // end of Form
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
    
    func deleteAndDismiss(_ shed: Shed) {
        Shed.delete(shed)
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
        Shed.updateData(using: editableData)
    }
}
