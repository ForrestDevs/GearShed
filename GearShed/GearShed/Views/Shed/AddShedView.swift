//
//  AddShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddShedView: View {
    
	@Environment(\.presentationMode) var presentationMode
	
	// all editableData is packaged here. its initial values are set using
	// a custom init.
	@State private var editableData: EditableItemData
    
    private var isAddFromItem: Bool
    private var shedOut: ((Shed) -> ())?
	private var shed: Shed?
	
	// custom init to set up editable data
	init(shed: Shed? = nil, shedOut: ((Shed) -> ())? = nil, isAddFromItem: Bool? = nil) {
		_editableData = State(initialValue: EditableItemData(shed: shed))
		self.shed = shed
        self.shedOut = shedOut
        self.isAddFromItem = isAddFromItem ?? false
	}

	var body: some View {
		Form {
			// 1: Name
			Section(header: Text("Basic Information").sectionHeader()) {
				HStack {
					SLFormLabelText(labelText: "Name: ")
					TextField("Shed name", text: $editableData.shedName)
                        .disableAutocorrection(true)

				}
			}
		}
		.onDisappear { PersistentStore.shared.saveContext() }
		.navigationBarTitle("Add New Shed", displayMode: .inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) { Text("Cancel") }
            }
			ToolbarItem(placement: .confirmationAction) {
                Button {
                    if isAddFromItem {
                        Shed.addNewShedFromItem(using: editableData, shedOut: { shed in shedOut!(shed) } )
                    } else {
                        Shed.updateData(using: editableData)
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: { Text("Save") } .disabled(!editableData.canShedBeSaved)
            }
		}
	}
}




