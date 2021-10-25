//
//  AddOrModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddBrandView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    
    var brand: Brand?
    
    // custom init to set up editable data
    init(brand: Brand? = nil) {
        _editableData = State(initialValue: EditableItemData(brand: brand))
        self.brand = brand
    }

    var body: some View {
            Form {
                // 1: Name
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Brand name", text: $editableData.brandName)
                    }
                }
            }
            .onDisappear { PersistentStore.shared.saveContext() }
            .navigationBarTitle("Add New Brand", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) { Text("Cancel") }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        Brand.updateData(using: editableData)
                    } label: { Text("Save") } .disabled(!editableData.canBrandBeSaved)
                }
            }
            .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
    }
}


