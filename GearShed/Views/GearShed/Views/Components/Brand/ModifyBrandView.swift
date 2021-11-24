//
//  ModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyBrandView: View {

    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData

    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    @State private var editableData: EditableBrandData
    
    init(persistentStore: PersistentStore, brand: Brand) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableBrandData(persistentStore: persistentStore, brand: brand)
        _editableData = State(initialValue: initialData)
    }
    
    var body: some View {
        NavigationView {
            viewContent
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelToolBarItem
                viewTitle
                saveToolBarItem
            }
            .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
        }
        .transition(.move(edge: .trailing))
    }
}

extension ModifyBrandView {
    
    // MARK: View Content
    private var viewContent: some View {
        ZStack {
            Color.theme.silver
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    Section {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Name")
                                .formatEntryTitle()
                            TextField("Brand Name (Required)", text: $editableData.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            
        }
    }
    
    // MARK: Toolbar Content
    
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showModifyBrand = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Brand Name")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyBrand = false
                }
                viewModel.updateBrand(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBrandBeSaved)
        }
    }
}




/*Section {
    if editableData.representsExistingBrand && !editableData.associatedBrand.isUnknownBrand {
        SLCenteredButton(title: "Delete This Brand",
                         action: { confirmDeleteBrandAlert = ConfirmDeleteBrandAlert(persistentStore: persistentStore
                        ,brand: editableData.associatedBrand,
                        destructiveCompletion: { presentationMode.wrappedValue.dismiss() }) }
        )
        .foregroundColor(Color.red)
    }
}*/


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


