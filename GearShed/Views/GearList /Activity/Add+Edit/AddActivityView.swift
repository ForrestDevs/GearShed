//
//  AddListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
import SwiftUI

struct AddActivityView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var detailManager: DetailViewManager
        
    @StateObject private var glData: GearlistData
    
    @State private var editableData: EditableGearlistData
        
    private let isAddFromType: Bool
    
    var body: some View {
        NavigationView {
            contentView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButtonToolBarItem
                viewTitle
                saveButtonToolBarItem
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
                    activityNameSection
                    activityTypeSection
                    activityDescriptionSection
                }
                .padding()
            }
        }
    }
    
    private var activityNameSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("Activity Name(Required)", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var activityTypeSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Type")
                    .formatEntryTitle()
                
                Menu {
                    // Add New Type Button
                    Button {
                        detailManager.content = AnyView (
                            AddActivityTypeView(persistentStore: persistentStore, typeOut: { type in
                                editableData.activityType = type
                            }).environmentObject(detailManager)
                        )
                        withAnimation {
                            detailManager.secondaryTarget = .showContent
                        }
                    } label: {
                        Text("Add New Type")
                        .font(.subheadline)
                    }
                    // List Of Current Types
                    ForEach(glData.activityTypes) { type in
                        Button {
                            editableData.activityType = type
                        } label: {
                            HStack {
                                Text(type.name)
                                    .tag(type)
                                    .font(.subheadline)
                                if editableData.activityType == type {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                        }
                    }
                } label: {
                    HStack {
                        Text(editableData.activityType?.name ?? "Select Activity Type")
                            .font(.subheadline)
                            .foregroundColor (typeTextColor())
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(8)
                    }
                    .background(Color.theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                    )
                }
            }
        }
    }

    private func typeTextColor() -> Color {
        var color: Color
        if editableData.activityType == nil {
            color = Color.theme.promptText
        } else {
            color = Color.theme.accent
        }
        return color
    }

    private var activityDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()
                TextField("Activity Description", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    // MARK: Toolbar Content
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
                /*if isAddFromType {
                    withAnimation {
                        detailManager.target = .noView
                        detailManager.showAddActivityFromActivityType = false
                    }
                } else {
                    withAnimation {
                        detailManager.showAddActivity = false
                    }
                }*/
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Add Activity")
                .formatGreen()
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let newGearList = glData.addNewGearlist(using: editableData)
                detailManager.selectedGearlist = newGearList
                /*if isAddFromType {
                    let newGearList = glData.addNewGearlist(using: editableData)
                    detailManager.selectedGearlist = newGearList
                } else {
                    let newGearList = glData.addNewGearlist(using: editableData)
                    detailManager.selectedGearlist = newGearList
                }*/
                withAnimation {
                    detailManager.secondaryTarget = .showAddItemsToGearlist
                    detailManager.target = .showGearlistDetail
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
}

extension AddActivityView {
    /// Initializer for loading Standard Add Activity
    init(persistentStore: PersistentStore) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, isTrip: false)
        _editableData = State(initialValue: initialValue)
        
        self.isAddFromType = false

    }
    
    /// Initializer for loading Add Activity with Type passed in
    init(persistentStore: PersistentStore, activityTypeIn: ActivityType) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, activityType: activityTypeIn)
        _editableData = State(initialValue: initialValue)
        
        self.isAddFromType = true
    }
}

