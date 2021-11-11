//
//  AddClusterView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct AddClusterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let persistentStore: PersistentStore
    
    let gearlist: Gearlist

    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditableClusterData

    private var clusterOut: ((Cluster) -> ())?
    
    @State private var isAddFromItem: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("New Cluster", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
    }
}

extension AddClusterView     {
     
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
                if isAddFromItem {
                    viewModel.addNewClusterFromItem(using: editableData, gearlist: gearlist) { cluster in
                        clusterOut!(cluster)
                    }
                } else {
                    viewModel.addNewCluster(using: editableData, gearlist: gearlist)
                }
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
                        TextField("Cluster Name", text: $editableData.name)
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

extension AddClusterView {
    
    /// Initializer for add a cluster from ItemRowView passing the cluster back.
    init(persistentStore: PersistentStore, gearlist: Gearlist, clusterOut: ((Cluster) -> ())? = nil) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        self.clusterOut = clusterOut
    
        _isAddFromItem = State(initialValue: true)
        
        let initialValue = EditableClusterData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    /// Initializer for Adding a cluster from ClusterView
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
    
        _isAddFromItem = State(initialValue: false)
        
        let initialValue = EditableClusterData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
}


