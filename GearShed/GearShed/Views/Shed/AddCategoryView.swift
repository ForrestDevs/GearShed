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
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) { Text("Cancel") }
            }
			ToolbarItem(placement: .confirmationAction) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    Category.updateData(using: editableData)
                } label: { Text("Save") } .disabled(!editableData.canCategoryBeSaved)
            }
		}
	}
}




