//
//  AddPileView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
import SwiftUI

struct AddPileView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
        
    let gearlist: Gearlist

    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditablePileData

    private var pileOut: ((Pile) -> ())?
    
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
                    detailManager.secondaryTarget = .noView
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
                    detailManager.secondaryTarget = .noView
                }
                if isAddFromItem {
                    viewModel.addNewPileFromItem(using: editableData, gearlist: gearlist) { pile in
                        pileOut!(pile)
                    }
                } else {
                    viewModel.addNewPile(using: editableData, gearlist: gearlist)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canPileBeSaved)
        }
    }
}

extension AddPileView {
    /// Initializer for add a pile from ItemRowView passing the pile back.
    init(persistentStore: PersistentStore, gearlist: Gearlist, pileOut: ((Pile) -> ())? = nil) {
        self.gearlist = gearlist
        self.pileOut = pileOut
    
        _isAddFromItem = State(initialValue: true)
        
        let initialValue = EditablePileData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    /// Initializer for Adding a pile from PileView
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
    
        _isAddFromItem = State(initialValue: false)
        
        let initialValue = EditablePileData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}


