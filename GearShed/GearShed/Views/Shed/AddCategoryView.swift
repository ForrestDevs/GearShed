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
    
	var shed: Shed?
	
	// custom init to set up editable data
	init(shed: Shed? = nil) {
		_editableData = State(initialValue: EditableItemData(shed: shed))
		self.shed = shed
	}

	var body: some View {
		Form {
			// 1: Name
			Section(header: Text("Basic Information").sectionHeader()) {
				HStack {
					SLFormLabelText(labelText: "Name: ")
					TextField("Shed name", text: $editableData.shedName)
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
                    presentationMode.wrappedValue.dismiss()
                    Shed.updateData(using: editableData)
                } label: { Text("Save") } .disabled(!editableData.canShedBeSaved)
            }
		}
	}
}




