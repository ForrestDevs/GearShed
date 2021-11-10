//
//  ModifyListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-08.
//

import SwiftUI

struct ModifyListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let persistentStore: PersistentStore
    
    let gearlist: Gearlist
    
    @StateObject private var viewModel: GearlistData

    @State private var editableData: EditableGearlistData
    
    @State private var isTrip: Bool = false
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, gearlist: gearlist)
        _editableData = State(initialValue: initialValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                contentLayer
            }
            .navigationBarTitle("New List", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
    }
}

extension ModifyListView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.updateGearlist(using: editableData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
    
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var contentLayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                listNameSection
                listDescriptionSection
                tripSection
            }
            .padding()
        }
    }
    
    private var listNameSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var listDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()

                TextField("", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
            }
        }
    }

    private var tripSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Toggle(isOn: $isTrip) {
                    Text("Is Trip List?")
                }
                if isTrip {
                    Text("Trip Length")
                    Text("Trip Location")
                    Text("")
                }
            }
        }
        
    }
    
}
