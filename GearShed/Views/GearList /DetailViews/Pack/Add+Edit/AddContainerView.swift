//
//  AddPackingGroupView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//
import SwiftUI

struct AddPackView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
        
    let gearlist: Gearlist
    
    @State private var editableData: EditablePackData
    
    @StateObject private var viewModel: GearlistData
    
    private var containerOut: ((Pack) -> ())?
    
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
                            TextField("Pack Name", text: $editableData.name)
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
    
    init(persistentStore: PersistentStore, gearlist: Gearlist, containerOut: ((Pack) -> ())? = nil) {
        self.gearlist = gearlist
        self.containerOut = containerOut
        _isAddFromItem = State(initialValue: true)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditablePackData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
    }
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
        _isAddFromItem = State(initialValue: false)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditablePackData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
    }
    
    
}


