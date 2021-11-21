//
//  ModifyActivityView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-19.
//

import SwiftUI

struct ModifyActivityView: View {
    
    let activity: Gearlist
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @StateObject private var glData: GearlistData

    @State private var editableData: EditableGearlistData
    
    @State private var isTrip: Bool = false
        
    init(persistentStore: PersistentStore, activity: Gearlist) {
        self.activity = activity
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, gearlist: activity)
        _editableData = State(initialValue: initialValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                contentLayer
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButtonToolBarItem
                viewTitle
                saveButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension ModifyActivityView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showModifyActivity = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyActivity = false
                }
                glData.updateGearlist(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Edit Activity")
                .formatGreen()
        }
    }
    
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var contentLayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                activityNameSection
                activityTypeSection
                activityDescriptionSection
            }
            .padding()
        }
    }
    
    private var activityNameSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.theme.green, lineWidth: 1)
                    )
                
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
                            detailManager.showContent = true
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
                            Text(type.name)
                                .tag(type)
                                .font(.subheadline)
                        }
                    }
                    
                } label: {
                    HStack {
                        Text(editableData.activityType?.name ?? "Select Activity Type")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.theme.green, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var activityDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()

                TextField("", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.theme.green, lineWidth: 1)
                    )

            }
        }
    }
}
