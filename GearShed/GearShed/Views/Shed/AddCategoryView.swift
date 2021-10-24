//
//  AddCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddCategoryView: View {
    
	@Environment(\.presentationMode) var presentationMode
	
	// all editableData is packaged here. its initial values are set using
	// a custom init.
	@State private var editableData: EditableItemData
	var category: Category?
	
	// parameter to control triggering an Alert and defining what action
	// to take upon confirmation
	@State private var confirmDeleteCategoryAlert: ConfirmDeleteCategoryAlert?
	
	// custom init to set up editable data
	init(category: Category? = nil) {
		_editableData = State(initialValue: EditableItemData(category: category))
		self.category = category
	}

	var body: some View {
		Form {
			// 1: Name
			Section(header: Text("Basic Information").sectionHeader()) {
				HStack {
					SLFormLabelText(labelText: "Name: ")
					TextField("Category name", text: $editableData.categoryName)
				}
			}
		}
		.onDisappear { PersistentStore.shared.saveContext() }
		.navigationBarTitle("Add New Category", displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .cancellationAction, content: cancelButton)
			ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canCategoryBeSaved) }
		}
		.alert(item: $confirmDeleteCategoryAlert) { item in item.alert() }
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
	}
	
}




