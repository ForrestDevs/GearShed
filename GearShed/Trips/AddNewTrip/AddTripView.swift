//
//  AddTripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// MARK: - View Definition

struct AddTripView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // this is the @FetchRequest that ties this view to Core Data Items
    @FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
    private var itemsToBePurchased: FetchedResults<Item>
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableTripData: EditableTripData
    var trip: Trip?
    
    // custom init to set up editable trip and item data
    init(trip: Trip? = nil, item: Item? = nil) {
        print("AddorModifyTripView initialized")
        _editableTripData = State(initialValue: EditableTripData(trip: trip))
        self.trip = trip
    }

    var body: some View {
        Form {
            // Section: Name
            Section(header: Text("Basic Information").sectionHeader()) {
                HStack {
                    SLFormLabelText(labelText: "Name: ")
                    TextField("Trip name", text: $editableTripData.tripName)
                }
            }
        } // end of Form
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Add New Trip", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: cancelButton)
                ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableTripData.canTripBeSaved) }
            }
    }
    
    // MARK: ADD TRIP FUNCTIONS

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
        Trip.updateData(using: editableTripData)
    }
    
}


