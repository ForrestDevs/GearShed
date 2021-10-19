//
//  AddorModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

struct AddOrModifyItemView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // this editableData struct contains all of the fields of an Item that
    // can be edited here, so that we're not doing a "live edit" on the Item.
    @State private var editableItemData: EditableItemData
    
    // FetchRequest To Keep Picker Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allCategorysFR())
    private var categorys: FetchedResults<Category>
    
    // FetchRequest To Keep Picker Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allBrandsFR())
    private var brands: FetchedResults<Brand>
    
    // FetchRequest To Keep Picker Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allTagsFR())
    private var tags: FetchedResults<Tag>
    
    // Environment state to dismiss page
	@Environment(\.presentationMode) var presentationMode
    
	// addItemToShoppingList just means that by default, a new item will be added to
	// the shopping list, and so this is initialized to true.
	// however, if inserting a new item from the Purchased item list, perhaps
	// you might want the new item to go to the Purchased item list (?)
	var addItemToShoppingList: Bool = true
	
	// custom init here to set up editableData state
    init(editableItem: Item? = nil, initialItemName: String? = nil, category: Category? = nil, brand: Brand? = nil, tag: Tag? = nil) {
		// initialize the editableData struct for the incoming item, if any; and
		// also carry in whatever might be a suggested Item name for a new Item
		if let item = editableItem {
			_editableItemData = State(initialValue: EditableItemData(item: item))
		} else {
			// here's we'll see if a suggested name for adding a new item was supplied
            let initialValue = EditableItemData(initialItemName: initialItemName, category: category,  brand: brand, tag: tag)
			_editableItemData = State(initialValue: initialValue)
		}
	}
	
	var body: some View {
        NavigationView {
            Form {
                
                // Section 1. Basic Information Fields
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack(alignment: .firstTextBaseline) {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Item name", text: $editableItemData.name)
                    }
                }
                Section(header: Text("Category").sectionHeader()) {
                    
                    DisclosureGroup("Category", isExpanded: $viewModel.expandedCategory) {
                        NavigationLink(destination: AddOrModifyCategoryView()) {
                            Text("Add New Category")
                        }
                        ForEach(categorys) { category in
                            Text(category.name).tag(category)
                                .onTapGesture {
                                    editableItemData.category = category
                                    viewModel.expandedCategory.toggle()
                                }
                        }
                    }
                }
                Section(header: Text("Brand").sectionHeader()) {

                    DisclosureGroup("Brand", isExpanded: $viewModel.expandedBrand) {
                        NavigationLink(destination: AddOrModifyBrandView()) {
                            Text("Add New Brand")
                        }
                        ForEach(brands) { brand in
                            Text(brand.name).tag(brand)
                                .onTapGesture {
                                    editableItemData.brand = brand
                                    viewModel.expandedBrand.toggle()
                                }
                        }
                    }
                }
                Section(header: Text("Tag").sectionHeader()) {

                    DisclosureGroup("Tag", isExpanded: $viewModel.expandedTag) {
                        NavigationLink(destination: AddOrModifyTagView()) {
                            Text("Add New Tag")
                        }
                        ForEach(tags) { tag in
                            Text(tag.name).tag(tag)
                                .onTapGesture {
                                    editableItemData.tag = tag
                                    viewModel.expandedTag.toggle()
                                }
                        }
                    }
                }
 
                // Item Stats
                Section (header: Text("Item Stats").sectionHeader()) {
                    Stepper(value: $editableItemData.weight, in: 1...10) {
                        HStack {
                            SLFormLabelText(labelText: "Weight: ")
                            Text("\(editableItemData.weight)")
                        }
                    }
                }
                
                // Item Details
                Section (header: Text("Item Details").sectionHeader()) {
                    TextEditor(text: $editableItemData.details) 
                }
                
                // Item Management (Delete), if present
                if editableItemData.representsExistingItem {
                    Section(header: Text("Item Management").sectionHeader()) {
                        SLCenteredButton(title: "Delete This Item",
                                         action: { viewModel.confirmDeleteItemAlert =
                                ConfirmDeleteItemAlert(item: editableItemData.associatedItem,
                                      destructiveCompletion: { presentationMode.wrappedValue.dismiss() })
                                                         })
                            .foregroundColor(Color.red)
                    }
                }
            } // end of Form
            .navigationBarTitle(barTitle(), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton() }
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableItemData.canBeSaved) }
            }
            .onAppear {
                logAppear(title: "AddOrModifyItemView")
            }
            .onDisappear {
                logDisappear(title: "AddOrModifyItemView")
                PersistentStore.shared.saveContext()
            }
            .alert(item: $viewModel.confirmDeleteItemAlert) { item in item.alert() }
        }
		
	}
		
	func barTitle() -> Text {
		return editableItemData.representsExistingItem ? Text("Modify Item") : Text("Add New Item")
	}
		
	// Cancel Button
	func cancelButton() -> some View {
        Button("Cancel",action: {presentationMode.wrappedValue.dismiss()})
	}
    
	// the save button
	func saveButton() -> some View {
		Button("Save", action: commitDataEntry)
	}
    
	// called when you tap the Save button.
	func commitDataEntry() {
		guard editableItemData.canBeSaved else { return }
        
		Item.updateData(using: editableItemData)
        
		presentationMode.wrappedValue.dismiss()
	}
	
}


