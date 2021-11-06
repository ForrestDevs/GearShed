//
//  AddPackingGroupView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-06.
//

import SwiftUI

struct AddPackingGroupView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore

    @State private var editableData: EditablePackingGroupData
    
    @StateObject private var viewModel: GearlistData
    
    private var packGroupOut: ((PackingGroup) -> ())?
    
    init(persistentStore: PersistentStore, packGroupOut: ((PackingGroup) -> ())? = nil) {
    
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditablePackingGroupData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialValue)
        
        self.packGroupOut = packGroupOut
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Add New Shed", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
    }
}

extension AddPackingGroupView {
    
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
                viewModel.addNewPackingGroupFromItem(using: editableData, packGroupOut: { packGroup in packGroupOut!(packGroup) })
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canPackGroupBeSaved)
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
                        TextField("Pack Group Name", text: $editableData.name)
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


