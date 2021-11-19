//
//  AddTripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import SwiftUI

struct AddAdventureView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
        
    @StateObject private var viewModel: GearlistData
    
    @State private var editableData: EditableGearlistData
    
    @State private var dateRange: ClosedRange<Date>? = nil

    @State private var showOverlay = false
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, isTrip: true)
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

extension AddAdventureView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showAddAdventure = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Add Adventure")
                .formatGreen()
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let newGearList = viewModel.addNewGearlist(using: editableData)
                detailManager.selectedGearlist = newGearList
                withAnimation {
                    detailManager.showAddAdventure = false
                    detailManager.showAddItemsToGearlist = true
                }
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
                adventureNameSection
                adventureDateSection
                adventureLocationSection
                adventureCountrySection
                adventureDescriptionSection
                
                
            }
            .padding()
        }
    }
    
    private var adventureNameSection: some View {
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
    
    private var adventureDateSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 2) {
                Text("Date")
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
                            Text("Select Both Start & End Dates").padding(.horizontal, 5)
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
    
    private var adventureLocationSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Location")
                    .formatEntryTitle()
                TextField("", text: $editableData.location ?? "")
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
    
    private var adventureCountrySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 3) {
                Text("Country")
                    .formatEntryTitle()
                TextField("", text: $editableData.location ?? "")
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
    
    private var adventureDescriptionSection: some View {
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

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}



