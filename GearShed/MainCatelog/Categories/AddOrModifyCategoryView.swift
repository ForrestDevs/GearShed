//
//  AddOrModifyCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// MARK: - View Definition

struct AddOrModifyCategoryView: View {
    
	@Environment(\.presentationMode) var presentationMode
	
	// all editableData is packaged here. its initial values are set using
	// a custom init.
	@State private var editableData: EditableItemData
	var category: Category?
	
	// parameter to control triggering an Alert and defining what action
	// to take upon confirmation
	@State private var confirmDeleteCategoryAlert: ConfirmDeleteCategoryAlert?
    
	// trigger for adding a new item at this Category
	//@State private var isAddNewItemSheetShowing = false
	
	// custom init to set up editable data
	init(category: Category? = nil) {
		_editableData = State(initialValue: EditableItemData(category: category))
		self.category = category
	}

	var body: some View {
		Form {
			// 1: Name, Colors
			Section(header: Text("Basic Information").sectionHeader()) {
				HStack {
					SLFormLabelText(labelText: "Name: ")
					TextField("Category name", text: $editableData.categoryName)
				}

				ColorPicker("Category Color", selection: $editableData.color)
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
			
			// Section 3: Items assigned to this Category, if we are editing a Category
			if editableData.representsExistingCategory {
				SimpleItemsList(category: editableData.associatedCategory/*,
												isAddNewItemSheetShowing: $isAddNewItemSheetShowing*/)
			}
			
		} // end of Form
		.onDisappear { PersistentStore.shared.saveContext() }
		.navigationBarTitle(barTitle(), displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .cancellationAction, content: cancelButton)
			ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableData.canCategoryBeSaved) }
		}
		.alert(item: $confirmDeleteCategoryAlert) { item in item.alert() }
		/*.sheet(isPresented: $isAddNewItemSheetShowing) {
			NavigationView {
				AddOrModifyItemView(category: category)
					.environment(\.managedObjectContext, PersistentStore.shared.context)
			}
		}*/

	}
	
	func barTitle() -> Text {
		return editableData.representsExistingCategory ? Text("Modify Category") : Text("Add New Category")
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
	}
	
}


struct SimpleItemsList: View {
	
	@FetchRequest	private var items: FetchedResults<Item>
	@State private var listDisplayID = UUID()
	//@Binding var isAddNewItemSheetShowing: Bool
	
	init(category: Category/*, isAddNewItemSheetShowing: Binding<Bool>*/) {
		let request = Item.allItemsFR(at: category)
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
//		.id(listDisplayID)
		.onAppear { listDisplayID = UUID() }
	}
	
	func ItemsListHeader() -> some View {
		HStack {
			Text("At this Category: \(items.count) items").sectionHeader()
			Spacer()
            
			//Button {
			//	isAddNewItemSheetShowing = true
			//} label: {
			//	Image(systemName: "plus")
			//		.font(.title2)
			//}
		}
	}
}
