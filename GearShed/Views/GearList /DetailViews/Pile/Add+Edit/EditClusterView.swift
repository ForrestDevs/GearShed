//
//  EditPileView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-11.
//

import SwiftUI

struct EditPileView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditablePileData
    
    init(persistentStore: PersistentStore, pile: Pile) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditablePileData(persistentStore: persistentStore, pile: pile)
        _editableData = State(initialValue: initialValue)
    }

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
}

extension EditPileView {
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
                    detailManager.secondaryTarget = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Pile Name")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
                viewModel.updatePile(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canPileBeSaved)
        }
    }
}


