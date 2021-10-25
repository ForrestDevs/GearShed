//
//  ModifyCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyCategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteCategoryAlert: ConfirmDeleteCategoryAlert?
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    
    var category: Category?
    
    // custom init to set up editable data
    init(category: Category? = nil) {
        _editableData = State(initialValue: EditableItemData(category: category))
        self.category = category
    }

    var body: some View {
        NavigationView {
            Form {
                // 1: Name, Colors
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Category name", text: $editableData.categoryName)
                    }
                } // end of Section 1
                
                // Section 2: Delete button, if present (must be editing a user category)
                if editableData.representsExistingCategory && !editableData.associatedCategory.isUnknownCategory {
                    Section(header: Text("Category Management").sectionHeader()) {
                        SLCenteredButton(title: "Delete This Category",
                                        action: { confirmDeleteCategoryAlert = ConfirmDeleteCategoryAlert(
                                        category: editableData.associatedCategory,
                                        destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                        )
                        .foregroundColor(Color.red)
                    }
                } // end of Section 2
            } // end of Form
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Edit Category", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canCategoryBeSaved) }
            }
            .alert(item: $confirmDeleteCategoryAlert) { item in item.alert() }
        }
    }
    
    func deleteAndDismiss(_ category: Category) {
        Category.delete(category)
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
        Category.updateData(using: editableData)
        //viewModel.updateViews()
    }
}
