//
//  AddorModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
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
    
    //@State var itemNameTextFieldTapped: Bool = false
    
    @State private var selectedBrandName: String = "Choose a Brand"
    
    @State private var selectedCategoryName: String = "Choose a Category"
    
    @State private var selectedBrand: Bool = false
    
    @State private var selectedCategory: Bool = false
	
	// custom init here to set up editableData state
    init(editableItem: Item? = nil, initialItemName: String? = nil, category: Category? = nil, brand: Brand? = nil/*, tag: Tag? = nil*/) {
		// initialize the editableData struct for the incoming item, if any; and
		// also carry in whatever might be a suggested Item name for a new Item
		if let item = editableItem {
			_editableItemData = State(initialValue: EditableItemData(item: item))
		} else {
			// here's we'll see if a suggested name for adding a new item was supplied
            let initialValue = EditableItemData(initialItemName: initialItemName, category: category,  brand: brand/*, tag: tag*/)
			_editableItemData = State(initialValue: initialValue)
		}
	}
	
	
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 20) {
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Item Name:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        TextField(editableItemData.name, text: $editableItemData.name).onTapGesture {
                            //itemNameTextFieldTapped = true
                        }
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 2)
                            .foregroundColor(Color.theme.green)
                    }
                    
                    VStack (alignment: .leading, spacing: 20) {
                        Text("Item Stats:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            TextField(editableItemData.weight, text: $editableItemData.weight)
                            
                            TextField(editableItemData.price, text: $editableItemData.price)
                        }
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Category - Brand")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        HStack (alignment: .firstTextBaseline, spacing: 10) {
                            
                            DisclosureGroup(selectedCategoryName, isExpanded: $viewModel.expandedCategory) {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: AddCategoryView()) {
                                        Text("Add New Category")
                                            .font(.caption)
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    ForEach(categorys) { category in
                                        HStack (spacing: 5) {
                                            if selectedCategory {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(Color.theme.green)
                                            }
                                            Text(category.name).tag(category)
                                                .font(.caption)
                                                .foregroundColor(Color.theme.secondaryText)
                                                .onTapGesture {
                                                    editableItemData.category = category
                                                    selectedCategory.toggle()
                                                    selectedCategoryName = category.name
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        viewModel.expandedCategory.toggle()
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            
                            DisclosureGroup(selectedBrandName, isExpanded: $viewModel.expandedBrand) {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: AddBrandView()) {
                                        Text("Add New Brand")
                                            .font(.title3)
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    ForEach(brands) { brand in
                                        HStack {
                                            if selectedBrand {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(Color.theme.green)
                                            }
                                            Text(brand.name).tag(brand)
                                                .font(.title3)
                                                .foregroundColor(Color.theme.secondaryText)
                                                .onTapGesture {
                                                    editableItemData.brand = brand
                                                    selectedBrand.toggle()
                                                    selectedBrandName = brand.name
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        viewModel.expandedBrand.toggle()
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            

                            
                            /*
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
                            */
                        }
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Quantity")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        
                        Stepper(value: $editableItemData.quantity, in: 1...50) {
                            HStack {
                                Spacer()
                                Text("\(editableItemData.quantity)")
                                Spacer()
                            }
                        }
                    }
                    
                    Toggle(isOn: $editableItemData.onList) {
                        Text("Wishlist Item")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Item Details:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color.theme.green)
                        TextEditor(text: $editableItemData.details)
                            .border(Color.theme.green)
                    }
                    
                    
                    // Item Management (Delete), if present
                    if editableItemData.representsExistingItem {
                        Section(header: Text("Item Management").sectionHeader()) {
                            
                            SLCenteredButton(title: "Delete This Item", action: { viewModel.confirmDeleteItemAlert =
                                ConfirmDeleteItemAlert(item: editableItemData.associatedItem,
                                    destructiveCompletion: { presentationMode.wrappedValue.dismiss() })
                            })
                            .foregroundColor(Color.red)
                        }
                    }
                }
                .padding()
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

struct AddOrModifyItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrModifyItemView()
    }
}


