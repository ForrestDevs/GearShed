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
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableData: EditableItemData
    
    private var isAddFromItem: Bool
    private var brandOut: ((Brand) -> ())?
    private var brand: Brand?
    
    // custom init to set up editable data
    init(brand: Brand? = nil, brandOut: ((Brand) -> ())? = nil, isAddFromItem: Bool? = nil) {
        _editableData = State(initialValue: EditableItemData(brand: brand))
        self.brand = brand
        self.brandOut = brandOut
        self.isAddFromItem = isAddFromItem ?? false
    }

    var body: some View {
            Form {
                // 1: Name
                Section(header: Text("Basic Information").sectionHeader()) {
                    HStack {
                        SLFormLabelText(labelText: "Name: ")
                        TextField("Brand name", text: $editableData.brandName)
                            .disableAutocorrection(true)

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
                        if isAddFromItem {
                            Brand.addNewBrandFromItem(using: editableData, brandOut: { brand in brandOut!(brand) })
                        } else {
                            Brand.updateData(using: editableData)
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: { Text("Save") } .disabled(!editableData.canBrandBeSaved)
                }
            }
    }
}


