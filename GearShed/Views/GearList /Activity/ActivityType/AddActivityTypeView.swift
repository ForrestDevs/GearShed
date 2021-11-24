//
//  AddActivityTypeView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-18.
//
import SwiftUI

struct AddActivityTypeView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @State private var editableData: EditableActivityTypeData
    @StateObject private var glData: GearlistData
    
    private var isAddFromList: Bool = false
    private var typeOut: ((ActivityType) -> ())?
    
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
                            TextField("Activity Type Name", text: $editableData.name)
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
                if isAddFromList {
                    withAnimation {
                        detailManager.showContent = false
                    }
                } else {
                    withAnimation {
                        detailManager.showAddActivityType = false
                    }
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Activity Type")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                if isAddFromList {
                    withAnimation {
                        detailManager.showContent = false
                    }
                    glData.addNewActivityType(using: editableData, typeOut: {
                        type in typeOut!(type) })
                } else {
                    withAnimation {
                        detailManager.showAddActivityType = false
                    }
                    glData.addNewActivityType(using: editableData)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
    
}

extension AddActivityTypeView {
    
    /// Initializer for loading standard Add ActivityType.
    init(persistentStore: PersistentStore) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialData = EditableActivityTypeData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
    }
    
    /// Initializer for loading Add Type from an Add Activity View.
    init(persistentStore: PersistentStore, typeOut: @escaping ((ActivityType) -> ()) ) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialData = EditableActivityTypeData(persistentStore: persistentStore)
        _editableData = State(initialValue: initialData)
        
        self.typeOut = typeOut
        self.isAddFromList = true
    }
    
}




