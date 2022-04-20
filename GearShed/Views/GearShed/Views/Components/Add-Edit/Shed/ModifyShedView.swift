//
//  ModifyShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//
import SwiftUI

struct ModifyShedView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var viewModel: GearShedData
    @State private var editableData: EditableShedData
    init(persistentStore: PersistentStore, shed: Shed) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableShedData(persistentStore: persistentStore, shed: shed)
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
        }
        .transition(.move(edge: .trailing))
    }
}

extension ModifyShedView {
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
                            TextField("Shelf Name (Required)", text: $editableData.name)
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
                    detailManager.target = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Shelf Name")
                .formatGreen()
        }
    }
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
                viewModel.updateShed(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canShedBeSaved)
        }
    }
}
