//
//  ModifyListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-08.
//

import SwiftUI

struct ModifyListView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    let gearlist: Gearlist
    
    @StateObject private var viewModel: GearlistData

    @State private var editableData: EditableGearlistData
    
    @State private var isTrip: Bool = false
    
    @State private var dateRange: ClosedRange<Date>? = nil
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.gearlist = gearlist
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, gearlist: gearlist)
        _editableData = State(initialValue: initialValue)
        
        if let initialStartDate = editableData.startDate {
            if let initialEndDate = editableData.endDate {
                let initialRange = [initialStartDate, initialEndDate]
                _dateRange = State(initialValue: initialRange[0]...initialRange[1])
            }
        }
        
        
        
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

extension ModifyListView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showModifyGearlist = false
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
                    detailManager.showModifyGearlist = false
                }
                viewModel.updateGearlist(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Edit List")
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
                listNameSection
                listDescriptionSection
                listLocationSection
                listDurationSection
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
    
    private var listLocationSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Location")
                    .formatEntryTitle()
                TextField("", text: $editableData.location ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var listDurationSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 2) {
                Text("Duration")
                    .formatEntryTitle()
                ZStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.theme.green, lineWidth: 1)
                        )
                        .foregroundColor(Color.theme.background)
                    Button {
                        withAnimation {
                            detailManager.showSecondaryContent = true
                            detailManager.secondaryContent = AnyView (
                                CustomDatePicker(dateRange: self.$dateRange)
                                    .environmentObject(detailManager)
                            )
                        }
                    } label: {
                        if let range = dateRange {
                            HStack {
                                Text(range.lowerBound.dateText(style: .medium))
                                Text("-")
                                Text(range.upperBound.dateText(style: .medium))
                            }.padding(.horizontal, 5)
                        } else {
                            Text("Select Start/End Dates").padding(.horizontal, 5)
                        }
                    }
                    .onChange(of: dateRange) { newValue in
                        editableData.startDate = newValue?.lowerBound
                        editableData.endDate = newValue?.upperBound
                    }
                }
            }
        }
    }

}
