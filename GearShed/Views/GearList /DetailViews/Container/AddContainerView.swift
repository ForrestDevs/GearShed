//
//  AddPackingGroupView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import SwiftUI

struct AddContainerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let persistentStore: PersistentStore
    
    let gearlist: Gearlist
    
    @State private var editableData: EditableContainerData
    
    @StateObject private var viewModel: GearlistData
    
    private var containerOut: ((Container) -> ())?
    
    @State private var isAddFromItem: Bool

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Add Container", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
    }
}

extension AddContainerView {
    
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
                    viewModel.addNewContainerFromItem(using: editableData, gearlist: gearlist) { container in
                        containerOut!(container)
                    }
                } else {
                    viewModel.addNewContainer(using: editableData, gearlist: gearlist)
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canContainerBeSaved)
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
                        TextField("Container Name", text: $editableData.name)
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

extension AddContainerView {
    
    init(persistentStore: PersistentStore, gearlist: Gearlist, containerOut: ((Container) -> ())? = nil) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        self.containerOut = containerOut
        
        _isAddFromItem = State(initialValue: true)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableContainerData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
    }
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        
        _isAddFromItem = State(initialValue: false)
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableContainerData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
    }
    
    
}


