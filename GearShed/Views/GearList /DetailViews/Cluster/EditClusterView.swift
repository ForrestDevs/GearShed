//
//  EditClusterView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-11.
//

import SwiftUI

struct EditClusterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @State private var editableData: EditableClusterData
    
    init(persistentStore: PersistentStore, cluster: Cluster) {
        let initialValue = EditableClusterData(persistentStore: persistentStore, cluster: cluster)
        _editableData = State(initialValue: initialValue)
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Edit Pile", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
    }
}

extension EditClusterView {
    
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
                viewModel.updateCluster(using: editableData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canClusterBeSaved)
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
                        TextField("Pile Name", text: $editableData.name)
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


