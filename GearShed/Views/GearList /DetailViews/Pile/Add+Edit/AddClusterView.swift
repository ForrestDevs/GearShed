//
//  AddClusterView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct AddClusterView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
        
    let gearlist: Gearlist

    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditableClusterData

    private var clusterOut: ((Cluster) -> ())?
    
    @State private var isAddFromItem: Bool
    
    var body: some View {
        NavigationView {
            contentView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelToolBarItem
                viewTitle
                saveToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    // MARK: Main Content
    private var contentView: some View {
        ZStack {
            Color.theme.silver
                .ignoresSafeArea()
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
    
    // MARK: Toolbar Content
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showContent = false
                    detailManager.showAddCluster = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Pile")
                .formatGreen()
        }
    }

    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showContent = false
                    detailManager.showAddCluster = false
                }
                if isAddFromItem {
                    viewModel.addNewClusterFromItem(using: editableData, gearlist: gearlist) { cluster in
                        clusterOut!(cluster)
                    }
                } else {
                    viewModel.addNewCluster(using: editableData, gearlist: gearlist)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canClusterBeSaved)
        }
    }
}

extension AddClusterView {
    /// Initializer for add a cluster from ItemRowView passing the cluster back.
    init(persistentStore: PersistentStore, gearlist: Gearlist, clusterOut: ((Cluster) -> ())? = nil) {
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
        self.gearlist = gearlist
    
        _isAddFromItem = State(initialValue: false)
        
        let initialValue = EditableClusterData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
}


