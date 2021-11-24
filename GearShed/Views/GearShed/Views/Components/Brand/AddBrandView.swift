//
//  AddOrModifyBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddBrandView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData
    
    @State private var editableData: EditableBrandData
    
    private var isAddFromItem: Bool = false
    private var brandOut: ((Brand) -> ())?
    
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

extension AddBrandView {
    
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
                            TextField("Brand Name (Required)", text: $editableData.name)
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
                        detailManager.showAddBrand = false
                    }
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Brand")
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
                    viewModel.addNewBrandFromItem(using: editableData, brandOut: { brand in brandOut!(brand) } )
                } else {
                    withAnimation {
                        detailManager.showAddBrand = false
                    }
                    viewModel.addNewBrand(using: editableData)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBrandBeSaved)
        }
    }
    
}

extension AddBrandView {
    
    /// Initializer for loading standard Add Brand
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableBrandData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
    }
    
    /// Initializer for loading Add Brand from Add Item. 
    init(persistentStore: PersistentStore, brandOut: @escaping ( (Brand) -> () ) ) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableBrandData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
        
        self.brandOut = brandOut
        self.isAddFromItem = true
    }
    
}


