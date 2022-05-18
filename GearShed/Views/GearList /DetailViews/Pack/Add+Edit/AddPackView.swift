//
//  AddPackView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AddPackView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var viewModel: GearlistData
    @State private var editableData: EditablePackData
    @State private var isAddFromItem: Bool
    private var containerOut: ((Pack) -> ())?
    let gearlist: Gearlist
   
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
                            TextField("Pack Name", text: $editableData.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .onTapGesture {
                    dismissKeyboard()
                }
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
            Text("Add Pack")
                .formatGreen()
        }
    }
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
                if isAddFromItem {
                    viewModel.addNewPackFromItem(using: editableData, gearlist: gearlist) { container in
                        containerOut!(container)
                    }
                } else {
                    viewModel.addNewPack(using: editableData, gearlist: gearlist)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canPackBeSaved)
        }
    }
}

extension AddPackView {
    /// Initializer for add a pack from ItemRowView passing the pack back.
    init(persistentStore: PersistentStore, gearlist: Gearlist, containerOut: ((Pack) -> ())? = nil) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let initialValue = EditablePackData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        self.gearlist = gearlist
        self.containerOut = containerOut
        _isAddFromItem = State(initialValue: true)
    }
    /// Initializer for Adding a pack from PackView
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        let initialValue = EditablePackData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        self.gearlist = gearlist
        _isAddFromItem = State(initialValue: false)
    }
}


