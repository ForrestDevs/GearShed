//
//  AddShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddShedView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    
	@State private var editableData: EditableShedData
    
    @StateObject private var viewModel: GearShedData
    
    private var isAddFromItem: Bool = false
    private var shedOut: ((Shed) -> ())?
    
	var body: some View {
        NavigationView {
            viewContent
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelToolBarItem
                viewTitle
                saveToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
	}
    
}

extension AddShedView {
    
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
                            TextField("Shed Name (Required)", text: $editableData.name)
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
                if isAddFromItem {
                    withAnimation {
                        detailManager.showContent = false
                    }
                } else {
                    withAnimation {
                        detailManager.showAddShed = false
                    }
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Shed")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                if isAddFromItem {
                    withAnimation {
                        detailManager.showContent = false
                    }
                    viewModel.addNewShedFromItem(using: editableData, shedOut: { shed in shedOut!(shed) })
                } else {
                    withAnimation {
                        detailManager.showAddShed = false
                    }
                    viewModel.addNewShed(using: editableData)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canShedBeSaved)
        }
    }
    
}

extension AddShedView {
    
    /// Initializer for loading standard Add Shed.
    init(persistentStore: PersistentStore) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableShedData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
    }
    
    /// Initializer for loading Add Shed from an Add Item View.
    init(persistentStore: PersistentStore, shedOut: @escaping ((Shed) -> ()) ) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableShedData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
        
        self.shedOut = shedOut
        self.isAddFromItem = true
    }
    
}
