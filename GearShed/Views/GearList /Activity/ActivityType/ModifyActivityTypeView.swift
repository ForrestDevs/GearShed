//
//  ModifyActivityTypeView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-18.
//

import SwiftUI

struct ModifyActivityTypeView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    @State private var editableData: EditableActivityTypeData
    @StateObject private var glData: GearlistData
    
    init(persistentStore: PersistentStore, activityType: ActivityType) {
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let initialData = EditableActivityTypeData(persistentStore: persistentStore, activityType: activityType)
        _editableData = State(initialValue: initialData)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
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

extension ModifyActivityTypeView {
    
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showModifyActivityType = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Activity Type Name")
                .formatGreen()
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyActivityType = false
                }
                glData.updateActivityType(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
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


