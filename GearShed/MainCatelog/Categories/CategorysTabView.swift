//
//  CategorysView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct CategoriesTabView: View {
	
	// this is the @FetchRequest that ties this view to CoreData Categories
	@FetchRequest(fetchRequest: MainCatelogVM.allCategorysFR())
	private var categories: FetchedResults<Category>
	
	// local state to trigger a sheet to appear to add a new category
	@State private var isAddNewCategorySheetShowing = false
	
	// parameters to control triggering an Alert and defining what action
	// to take upon confirmation
	//@State private var confirmationAlert = ConfirmationAlert(type: .none)
	@State private var confirmDeleteCategoryAlert: ConfirmDeleteCategoryAlert?

	// this implements a seemingly well-known strategy to get the list drawn
	// cleanly without any highlighting
	@State private var listDisplayID = UUID()
	
	var body: some View {
		VStack(spacing: 0) {
			
			// 1. add new category "button" is at top.  note that this will put up the
			// AddorModifyCategoryView inside its own NavigationView (so the Picker will work!)
			Button(action: { isAddNewCategorySheetShowing = true }) {
			//	Text("Add New Category")
			//		.foregroundColor(Color.blue)
			//		.padding(10)
			}
			.sheet(isPresented: $isAddNewCategorySheetShowing) {
				NavigationView { AddOrModifyCategoryView() }
			}
			
			Rectangle()
				.frame(height: 1)
			
			
			// 2. then the list of categories
			//Form {
			//	Section(header: Text("Categorys Listed: \(categories.count)").sectionHeader()) {
			//		ForEach(categories) { category in
			//			NavigationLink(destination: AddOrModifyCategoryView(category: category)) //{
            //                CategoryRowView(category: category, rowData: //CategoryRowData(category: category))
			//					.contextMenu { contextMenuButton(for: category) }
			//			} // end of NavigationLink
			//		} // end of ForEach
			//	} // end of Section
			//} // end of Form
			//				.id(listDisplayID)
			
		} // end of VStack
		.navigationBarTitle("Categories")
		.toolbar { ToolbarItem(placement: .navigationBarTrailing, content: addNewButton) }
		//.alert(isPresented: $confirmationAlert.isShowing) { confirmationAlert.alert() }
		.alert(item: $confirmDeleteCategoryAlert) { item in item.alert() }
		.onAppear {
			logAppear(title: "CategorysTabView")
			handleOnAppear()
		}
		.onDisappear() {
			logDisappear(title: "CategorysTabView")
			PersistentStore.shared.saveContext()
		}
		
	} // end of var body: some View
	
	func handleOnAppear() {
		// updating listDisplayID makes SwiftUI think the list of categories is a whole new
		// list, thereby removing any highlighting.
		listDisplayID = UUID()
		// because the unknown category is created lazily, this will make sure that
		// we'll not be left with an empty screen
		if categories.count == 0 {
			let _ = Category.unknownCategory()
		}
	}
	
	// defines the usual "+" button to add a Category
	func addNewButton() -> some View {
		Button(action: { isAddNewCategorySheetShowing = true }) {
			Image(systemName: "plus")
				.font(.title2)
		}
	}
	
	// a convenient way to build this context menu without having it in-line
	// in the view code above
	@ViewBuilder
	func contextMenuButton(for category: Category) -> some View {
		Button(action: {
			if !category.isUnknownCategory {
				confirmDeleteCategoryAlert = ConfirmDeleteCategoryAlert(category: category)
				//confirmationAlert.trigger(type: .deleteCategory(category))
			}
		}) {
			Text(category.isUnknownCategory ? "(Cannot be deleted)" : "Delete This Category")
			Image(systemName: category.isUnknownCategory ? "trash.slash" : "trash")
		}
	}
	
}
