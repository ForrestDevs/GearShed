//
//  ModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData

    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    @State private var editableData: EditableBrandData
    
    var brand: Brand?
    
    init(persistentStore: PersistentStore, brand: Brand? = nil) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        _editableData = State(initialValue: EditableBrandData(brand: brand))
        self.brand = brand
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Edit Brand", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
            .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
        }
    }
}

extension ModifyBrandView {
    
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.updateBrand(using: editableData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBrandBeSaved)
        }
    }
    
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var scrollViewLayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Section {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Name")
                            .formatEntryTitle()
                        TextField("", text: $editableData.brandName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.subheadline)
                    }
                }
                Section {
                    if editableData.representsExistingBrand && !editableData.associatedBrand.isUnknownBrand {
                        SLCenteredButton(title: "Delete This Brand",
                                         action: { confirmDeleteBrandAlert = ConfirmDeleteBrandAlert(persistentStore: persistentStore
                                        ,brand: editableData.associatedBrand,
                                        destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
                        )
                        .foregroundColor(Color.red)
                    }
                }
            }
            .padding()
        }
    }
}

/*
 
 private func deleteAndDismiss(_ brand: Brand) {
     Brand.delete(brand)
     presentationMode.wrappedValue.dismiss()
 }

 private func cancelButton() -> some View {
     Button(action: { presentationMode.wrappedValue.dismiss() }) {
         Text("Cancel")
     }
 }
 
 private func saveButton() -> some View {
     Button(action: commitData) {
         Text("Save")
     }
 }

 private func commitData() {
     presentationMode.wrappedValue.dismiss()
     Brand.updateData(using: editableData)
 }
 */


