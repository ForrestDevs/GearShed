//
//  ItemListDisplay.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ItemListDisplay

// this is a subview of the ShoppingListTabView and shows itemsToBePurchased
// as either a single section or as multiple sections, one section for each Category.
// it uses a somewhat intricate, but standard,Form/ForEach/Section/ForEach construct
// to present the list in sections and requires some preliminary work to perform the
// sectioning.
//
// each item that appears has a NavigationLink to a detail view and has a contextMenu
// associated with it; actions from the contextMenu may require bringing up an alert,
// but we will not do that here in this view.  we will simply set @Binding variables
// from the parent view appropriately and let the parent deal with it (e.g., because
// the parent uses the same structure to present an alert already to move all items
// off the list).
struct ItemListDisplay: View {
	
	// this is the @FetchRequest that ties this view to Core Data Items
	@FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
	private var allItems: FetchedResults<Item>

	// display format: one big section of Items, or sectioned by Category?
	// (not sure we need a Binding here ... we only read the value)
	@Binding var multiSectionDisplay: Bool
	
	// state variable to control triggering confirmation of a delete, which is
	// one of three context menu actions that can be applied to an item
	@State var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
	
	// this is a temporary holding array for items being moved to the other list.  it's a
	// @State variable, so if any SelectableItemRowView or a context menu adds an Item
	// to this array, we will get some redrawing + animation; and we'll also have queued
	// the actual execution of the move to the purchased list to follow after the animation
	// completes -- and that deletion will again change this array and redraw.
	@State private var itemsChecked = [Item]()
	
	// this implements a seemingly well-known strategy to get the list drawn
	// cleanly without any highlighting
//	@Binding var listDisplayID: UUID

	var body: some View {
		List {
			ForEach(sectionData()) { section in
				Section(header: Text(section.title).sectionHeader()) {
					// display items in this category
					ForEach(section.items) { item in
						// display a single row here for 'item'
						NavigationLink(destination: AddOrModifyItemView(editableItem: item)) {
							ItemRowView(item: item)
								.contextMenu {
									itemContextMenu(item: item, deletionTrigger: {
										confirmDeleteItemAlert = ConfirmDeleteItemAlert(item: item)
									})
								} // end of contextMenu
						}
                        // end of NavigationLink
					}
                    // end of ForEach
				}
                // end of Section
			}
            // end of ForEach
		}
        // end of List
        
//		.id(listDisplayID)
		.listStyle(InsetGroupedListStyle())
		.alert(item: $confirmDeleteItemAlert) { item in item.alert() }

	} // end of body: some View
	
	// the purpose of this function is to break out the allItems by section,
	// according to whether the list is displayed as a single section or in multiple
	// sections (one for each Category that contains shopping items on the list)
	func sectionData() -> [SectionData] {
		
		// the easy case: if this is not a multi-section list, there will be one section with a title
		// and an array of all the items
		if !multiSectionDisplay {
			// if you want to change the sorting when this is a single section to "by name"
			// then comment out the .sorted() qualifier -- itemsToBePurchased is already sorted by name
			let sortedItems = allItems
				.sorted(by: { $0.category.visitationOrder < $1.category.visitationOrder })
			return [SectionData(title: "Total Items: \(allItems.count)", items: sortedItems)
			]
		}
		
		// otherwise, one section for each category, please.  break the data out by category first
		let dictionaryByCategory = Dictionary(grouping: allItems, by: { $0.category })
		// then reassemble the sections by sorted keys of this dictionary
		var completedSectionData = [SectionData]()
		for key in dictionaryByCategory.keys.sorted() {
			completedSectionData.append(SectionData(title: key.name, items: dictionaryByCategory[key]!))
		}
		return completedSectionData
	}
	
	
	
}




