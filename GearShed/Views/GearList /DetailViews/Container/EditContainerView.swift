//
//  EditContainerView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-11.
//

import SwiftUI

struct EditContainerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @State private var editableData: EditableContainerData
    
    init(persistentStore: PersistentStore, container: Container) {
        let initialValue = EditableContainerData(persistentStore: persistentStore, container: container)
        _editableData = State(initialValue: initialValue)
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Edit Container", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
    }
}

extension EditContainerView {
    
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
                viewModel.updateContainer(using: editableData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canContainerBeSaved)
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
                        TextField("Container Name", text: $editableData.name)
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


