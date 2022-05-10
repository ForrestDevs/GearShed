//
//  AddShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AddShedView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var viewModel: GearShedData
	@State private var editableData: EditableShedData
    
  //  @State private var shedNames: [String] = []
//    @State private var test1: String = ""
//    @State private var test2: String = ""
    
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
                            TextField("Shelf Name (Required)", text: $editableData.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .font(.subheadline)
                            
//                            if !isAddFromItem {
//                                ForEach($shedNames, id: \.self) { name in
//                                    TextField("Shelf Name (Required)", text: name)
//                                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                                        .disableAutocorrection(true)
//                                        .font(.subheadline)
//
//                                }
//                                Button {
//                                    shedNames.append(editableData.name)
//                                    editableData.name = ""
//
//                                    //self.shedNames.append("")
//
//                                    //editableData.nameArray.append("")
//                                } label: {
//                                    Image(systemName: "plus.circle")
//                                        .foregroundColor(Color.black)
//                                }
//                            }
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
                    detailManager.tertiaryTarget = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Shelf")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.tertiaryTarget = .noView
                }
                if isAddFromItem {
                    viewModel.addNewShedFromItem(using: editableData, shedOut: { shed in shedOut!(shed) })
                } else {
                    viewModel.addNewShed(using: editableData)
                    //viewModel.addMultipleSheds(using: editableData)
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
