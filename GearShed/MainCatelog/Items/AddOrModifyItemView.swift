//
//  AddorModifyItemView.swift
//  ShoppingList
//
//  Created by Jerry on 5/3/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import SwiftUI

struct AddOrModifyItemView: View {
    
	// we use this so we can dismiss ourself (sometimes we're in a Sheet, sometimes
	// in a NavigationLink)
	@Environment(\.presentationMode) var presentationMode

    // Clever Hack To Allow SheetView Buttons Work Even if Sheet has been Partially Dismissed
    private let dg = DragGesture()
    
	// addItemToShoppingList just means that by default, a new item will be added to
	// the shopping list, and so this is initialized to true.
	// however, if inserting a new item from the Purchased item list, perhaps
	// you might want the new item to go to the Purchased item list (?)
	var addItemToShoppingList: Bool = true
	
	// this editableData struct contains all of the fields of an Item that
	// can be edited here, so that we're not doing a "live edit" on the Item.
	@State private var editableItemData: EditableItemData

	// parameters to control triggering an Alert and defining what action
	// to take upon confirmation
	//@State private var confirmationAlert = ConfirmationAlert(type: .none)
	@State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
	
    /* /////////////////////////// */
    //Create a state var for the category picker section
    @State private var categoryChooser = 0
    //Create a state var for the brand picker section
    @State private var brandChooser = 0
    /* /////////////////////////// */
    
	// we need all categorys so we can populate the Picker.  it may be curious that i
	// use a @FetchRequest here; the problem is that if this Add/ModifyItem view is open
	// to add a new item, then we tab over to the Categorys tab to add a new category,
	// we have to be sure the Picker's list of categorys is updated.
	@FetchRequest(fetchRequest: Category.allCategorysFR())
	private var categorys: FetchedResults<Category>
    
    // we need all brands so we can populate the Picker.  it may be curious that i
    // use a @FetchRequest here; the problem is that if this Add/ModifyItem view is open
    // to add a new item, then we tab over to the Categorys tab to add a new category,
    // we have to be sure the Picker's list of categorys is updated.
    @FetchRequest(fetchRequest: Brand.allBrandsFR())
    private var brands: FetchedResults<Brand>
	
	// custom init here to set up editableData state
    init(editableItem: Item? = nil, initialItemName: String? = nil, category: Category? = nil, brand: Brand? = nil) {
		// initialize the editableData struct for the incoming item, if any; and
		// also carry in whatever might be a suggested Item name for a new Item
		if let item = editableItem {
			_editableItemData = State(initialValue: EditableItemData(item: item))
		} else {
			// here's we'll see if a suggested name for adding a new item was supplied
			let initialValue = EditableItemData(initialItemName: initialItemName, category: category,  brand: brand)
			_editableItemData = State(initialValue: initialValue)
		}
	}
	
	var body: some View {
		Form {
            
			// Section 1. Basic Information Fields
			Section(header: Text("Basic Information").sectionHeader()) {
				HStack(alignment: .firstTextBaseline) {
					SLFormLabelText(labelText: "Name: ")
					TextField("Item name", text: $editableItemData.name)
				}
			}
 
           // Category Section
            Section(header: Text("Category").sectionHeader()) {
               Picker(selection: $editableItemData.category, label: SLFormLabelText(labelText: "Category: ")) {
                    ForEach(categorys) { category in
                        Text(category.name).tag(category)
                  }
               }
            }
           
            // Brand Section
            Section(header: Text("Brand").sectionHeader()) {
                Picker(selection: $editableItemData.brand, label: SLFormLabelText(labelText: "Brand: ")) {
                    ForEach(brands) { brand in
                        Text(brand.name).tag(brand)
                    }
                }
            }

            // Item Stats
            Section (header: Text("Item Stats").sectionHeader()) {
                Stepper(value: $editableItemData.quantity, in: 1...10) {
                    HStack {
                        SLFormLabelText(labelText: "Weight: ")
                        Text("\(editableItemData.quantity)")
                    }
                }
            }
            
            // Item Management (Delete), if present
            if editableItemData.representsExistingItem {
                Section(header: Text("Shopping Item Management").sectionHeader()) {
                    SLCenteredButton(title: "Delete This Shopping Item",
                        action: { confirmDeleteItemAlert =
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
			handleOnAppear()
		}
		.onDisappear {
			logDisappear(title: "AddOrModifyItemView")
			PersistentStore.shared.saveContext()
		}
		//.alert(isPresented: $confirmationAlert.isShowing) { confirmationAlert.alert() }
		.alert(item: $confirmDeleteItemAlert) { item in item.alert() }
	}
		
	func barTitle() -> Text {
		return editableItemData.representsExistingItem ? Text("Modify Item") : Text("Add New Item")
	}
	
	func handleOnAppear() {
		// what follows here is a kludge for a very special case:
		// -- we were in the ShoppingListTabView
		// -- we navigate to this Add/ModifyItem view for an Item X at Category Y
		// -- we use the tab bar to move to the Categorys tab
		// -- we select Category Y and navigate to its Add/ModifyCategory view
		// -- we tap Item X listed for Category Y, opening a second Add/ModifyItem view for Item X
		// -- we delete Item X in this second Add/ModifyItem view
		// -- we use the tab bar to come back to the shopping list tab, and
		// -- this view is now what's on-screen, showing us an item that was deleted underneath us (!)
		//
		// the only thing that makes sense is to dismiss ourself in the case that we were instantiated
		// with a real item (editableData.id != nil) but that item does not exist anymore.
		
		if editableItemData.representsExistingItem && Item.object(withID: editableItemData.id!) == nil {
			presentationMode.wrappedValue.dismiss()
		}
		
		// by the way, this applies symmetrically to opening an Add/ModifyItem view from the
		// Add/ModifyCategory view, then tabbing over to the shopping list, looking at a second
		// Add/ModifyItem view there and deleting.  the first Add/ModifyItem view will get the
		// same treatment in this code, getting dismissed when it tries to come back on screen.
		
		// ADDITIONAL DISCUSSION:
		//
		// apart from the delete operation, when two instances of the Add/ModifyItem view are
		// active, any edits made to item data in one will not be replicated in the other, because
		// these views copy data to their local @State variable editableData, and that is what
		// gets edited.  so if you do a partial edit in one of the views, when you visit the second
		// view, you will not see those changes.  this is a natural side-effect of doing an edit
		// on a draft copy of the data and not doing a live edit.  we are aware of the problem
		// and may look to fix this in the future.  (two strategies come to mind: a live edit of an
		// ObservableObject, which then means we have to rethink combining the add and modify
		// functions; or always doing the Add/Modify view as a .sheet so that you cannot so easily
		// navigate elsewhere in the app and make edits underneath this view.)
		
		// a third possibility offered by user jjatie on 7 Jan, 2021, on the Apple Developer's Forum
		//   https://developer.apple.com/forums/thread/670564
		// suggests tapping into the NotificationCenter to watch for changes in the NSManaged
		// context, and checking to see if the Item is among those in the notification's
		// userInfo[NSManagedObjectContext.NotificationKey.deletedObjectIDs].

	}
	
	// the cancel button
	func cancelButton() -> some View {
		Button("Cancel",
					 action: { presentationMode.wrappedValue.dismiss() })
	}
    
	
	// the save button
	func saveButton() -> some View {
		Button("Save",
					 action: commitDataEntry)
	}
    
	
	// called when you tap the Save button.
	func commitDataEntry() {
		guard editableItemData.canBeSaved else { return }
        
		Item.updateData(using: editableItemData)
        
		presentationMode.wrappedValue.dismiss()
	}
	
}

struct ModalView1 : View {
@Environment(\.presentationMode) var presentationMode

let dg = DragGesture()

var body: some View {

    ZStack {
        Rectangle()
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .highPriorityGesture(dg)

        Button("Dismiss Modal") {
            self.presentationMode.wrappedValue.dismiss()
        }
        
    }
  }
}

struct ModalView : View {
    
    @Environment(\.presentationMode) var presentationMode

    let dg = DragGesture()

    var body: some View {
        Button("Dismiss Modal") {
            self.presentationMode.wrappedValue.dismiss()
        }
        .highPriorityGesture(dg)
    }
}

