//
//  AddOrModifyTagView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

//import SwiftUI

/*struct AddOrModifyTagView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    var tag: Tag?
    
    // custom init to set up editable data
    init(tag: Tag? = nil) {
        _editableData = State(initialValue: EditableItemData(tag: tag))
        self.tag = tag
    }
    
    var body: some View {
        Form {
            // 1: Name
            Section(header: Text("Basic Information").sectionHeader()) {
                HStack {
                    SLFormLabelText(labelText: "Name: ")
                    TextField("Tag name", text: $editableData.tagName)
                }
            } // end of Section 1
            
            // Section 2: Delete button, if present (must be editing a user tag)
            if editableData.representsExistingTag && !editableData.associatedTag.isUnknownTag {
                Section(header: Text("Tag Management").sectionHeader()) {
                    SLCenteredButton(title: "Delete This Tag",
                                     action: { viewModel.confirmDeleteTagAlert = ConfirmDeleteTagAlert(
                                    tag: editableData.associatedTag,
                                    destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                    )
                    .foregroundColor(Color.red)
                }
            }
        } // end of Form
        .onDisappear { PersistentStore.shared.saveContext() }
        .navigationBarTitle(barTitle(), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
            ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canTagBeSaved) }
        }
        .alert(item: $viewModel.confirmDeleteTagAlert) { item in item.alert() }
    }
    
    func barTitle() -> Text {
        return editableData.representsExistingTag ? Text("Modify Tag") : Text("Add New Tag")
    }
    
    func deleteAndDismiss(_ tag: Tag) {
        Tag.delete(tag)
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
        Tag.updateData(using: editableData)
    }
}*/
