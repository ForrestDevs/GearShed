//
//  ShedsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

//import SwiftUI

/*struct ShedsTabView: View {
	
	// this is the @FetchRequest that ties this view to CoreData Sheds
	@FetchRequest(fetchRequest: MainCatelogVM.allShedsFR())
	private var sheds: FetchedResults<Shed>
	
	// local state to trigger a sheet to appear to add a new shed
	@State private var isAddNewShedSheetShowing = false
	
	// parameters to control triggering an Alert and defining what action
	// to take upon confirmation
	//@State private var confirmationAlert = ConfirmationAlert(type: .none)
	@State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?

	// this implements a seemingly well-known strategy to get the list drawn
	// cleanly without any highlighting
	@State private var listDisplayID = UUID()
	
	var body: some View {
		VStack(spacing: 0) {
			
			// 1. add new shed "button" is at top.  note that this will put up the
			// AddorModifyShedView inside its own NavigationView (so the Picker will work!)
			Button(action: { isAddNewShedSheetShowing = true }) {
			//	Text("Add New Shed")
			//		.foregroundColor(Color.blue)
			//		.padding(10)
			}
			.sheet(isPresented: $isAddNewShedSheetShowing) {
				NavigationView { AddShedView() }
			}
			
			Rectangle()
				.frame(height: 1)
			
			
			// 2. then the list of sheds
			//Form {
			//	Section(header: Text("Sheds Listed: \(sheds.count)").sectionHeader()) {
			//		ForEach(sheds) { shed in
			//			NavigationLink(destination: AddOrModifyShedView(shed: shed)) //{
            //                ShedRowView(shed: shed, rowData: //ShedRowData(shed: shed))
			//					.contextMenu { contextMenuButton(for: shed) }
			//			} // end of NavigationLink
			//		} // end of ForEach
			//	} // end of Section
			//} // end of Form
			//				.id(listDisplayID)
			
		} // end of VStack
		.navigationBarTitle("Sheds")
		.toolbar { ToolbarItem(placement: .navigationBarTrailing, content: addNewButton) }
		//.alert(isPresented: $confirmationAlert.isShowing) { confirmationAlert.alert() }
		.alert(item: $confirmDeleteShedAlert) { item in item.alert() }
		.onAppear {
			logAppear(title: "ShedsTabView")
			handleOnAppear()
		}
		.onDisappear() {
			logDisappear(title: "ShedsTabView")
			PersistentStore.shared.saveContext()
		}
		
	} // end of var body: some View
	
	func handleOnAppear() {
		// updating listDisplayID makes SwiftUI think the list of sheds is a whole new
		// list, thereby removing any highlighting.
		listDisplayID = UUID()
		// because the unknown shed is created lazily, this will make sure that
		// we'll not be left with an empty screen
		if sheds.count == 0 {
			let _ = Shed.unknownShed()
		}
	}
	
	// defines the usual "+" button to add a Shed
	func addNewButton() -> some View {
		Button(action: { isAddNewShedSheetShowing = true }) {
			Image(systemName: "plus")
				.font(.title2)
		}
	}
	
	// a convenient way to build this context menu without having it in-line
	// in the view code above
	@ViewBuilder
	func contextMenuButton(for shed: Shed) -> some View {
		Button(action: {
			if !shed.isUnknownShed {
				confirmDeleteShedAlert = ConfirmDeleteShedAlert(shed: shed)
				//confirmationAlert.trigger(type: .deleteShed(shed))
			}
		}) {
			Text(shed.isUnknownShed ? "(Cannot be deleted)" : "Delete This Shed")
			Image(systemName: shed.isUnknownShed ? "trash.slash" : "trash")
		}
	}
	
}*/
