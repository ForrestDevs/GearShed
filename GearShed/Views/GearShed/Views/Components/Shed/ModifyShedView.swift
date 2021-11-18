//
//  ModifyShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyShedView: View {

    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData

    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    @State private var editableData: EditableShedData
        
    init(persistentStore: PersistentStore, shed: Shed) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableShedData(persistentStore: persistentStore, shed: shed)
        _editableData = State(initialValue: initialData)
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelToolBarItem
                viewTitle
                saveToolBarItem
            }
            .alert(item: $confirmDeleteShedAlert) { shed in shed.alert() }
        }
        .transition(.move(edge: .trailing))
    }
}

extension ModifyShedView {
    
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showModifyShed = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Shed Name")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyShed = false
                }
                viewModel.updateShed(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canShedBeSaved)
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
                        TextField("Shed name", text: $editableData.name)
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

/*Section {
    if editableData.representsExistingShed && !editableData.associatedShed.isUnknownShed {
        SLCenteredButton(title: "Delete This Shed",
                        action: { confirmDeleteShedAlert = ConfirmDeleteShedAlert (
                            persistentStore: persistentStore,
                            shed: editableData.associatedShed,
                            destructiveCompletion: {
                                presentationMode.wrappedValue.dismiss()
                            }) }
        )
        .foregroundColor(Color.red)
    }
}*/

/*
 private func deleteAndDismiss(_ shed: Shed) {
     Shed.delete(shed)
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
     Shed.updateData(using: editableData)
 }
 
 */
