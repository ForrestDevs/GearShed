//
//  ModifyShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ModifyShedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData

    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    @State private var editableData: EditableShedData
    
    var shed: Shed?
    
    init(persistentStore: PersistentStore, shed: Shed? = nil) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        _editableData = State(initialValue: EditableShedData(shed: shed))
        self.shed = shed
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Edit Shed", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
            .alert(item: $confirmDeleteShedAlert) { shed in shed.alert() }
        }
    }
}

extension ModifyShedView {
    
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
                viewModel.updateShed(using: editableData)
                presentationMode.wrappedValue.dismiss()
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
                        TextField("Shed name", text: $editableData.shedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.subheadline)
                    }
                }
                Section {
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
                }
            }
            .padding()
        }
    }
    
}

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
