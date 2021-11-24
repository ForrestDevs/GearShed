//
//  ModifyListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-08.
//
import SwiftUI

struct ModifyAdventureView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @StateObject private var viewModel: GearlistData

    @State private var editableData: EditableGearlistData
        
    @State private var dateRange: ClosedRange<Date>? = nil
    
    init(persistentStore: PersistentStore, adventure: Gearlist) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, gearlist: adventure)
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
                    adventureNameSection
                    adventureDateSection
                    adventureLocationSection
                    adventureCountrySection
                    adventureDescriptionSection
                }
                .padding()
            }
        }
    }
    
    private var adventureNameSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("Adventure Name (Required)", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var adventureDateSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 2) {
                Text("Date")
                    .formatEntryTitle()
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
                        }
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(8)
                    } else {
                        Text("Select Both Start & End Dates (Required)")
                            .foregroundColor(Color.theme.promptText)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(8)
                    }
                }
                .background(Color.theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                )
                .onChange(of: dateRange) { newValue in
                    editableData.startDate = newValue?.lowerBound
                    editableData.endDate = newValue?.upperBound
                }
            }
        }
    }
    
    private var adventureLocationSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Location")
                    .formatEntryTitle()
                TextField("Adventure Location", text: $editableData.location ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var adventureCountrySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Country")
                    .formatEntryTitle()
                TextField("Adventure Country", text: $editableData.country ?? "")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var adventureDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()
                TextField("Adventure Description", text: $editableData.details)
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
                    detailManager.showModifyAdventure = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Edit Adventure")
                .formatGreen()
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyAdventure = false
                }
                viewModel.updateGearlist(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canGearlistBeSaved)
        }
    }
}
