//
//  AddTripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import SwiftUI

struct AddTripView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var viewModel: GearlistData
    
    let persistentStore: PersistentStore
    
    @State private var editableData: EditableGearlistData
    
    @State private var dateRange: ClosedRange<Date>? = nil

    @State private var showOverlay = false

    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let initialValue = EditableGearlistData(persistentStore: persistentStore, isTrip: true)
        _editableData = State(initialValue: initialValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                contentLayer
            }
            .navigationBarTitle("Add Trip", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolBarItem
                saveButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
    
}

extension AddTripView {
    
    private var cancelButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showAddNewGearlist = false
                }
            } label:  {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let newGearList = viewModel.addNewGearlist(using: editableData)
                withAnimation {
                    detailManager.showAddNewGearlist = false
                    detailManager.content = AnyView (
                        AddItemsToGearListView(persistentStore: persistentStore, gearlist: newGearList)
                            .environmentObject(detailManager)
                            .environmentObject(viewModel)
                    )
                    detailManager.showSelectGearlistItems = true
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
                tripNameSection
                tripDescriptionSection
                tripLocationSection
                tripDurationSection
            }
            .padding()
        }
    }
    
    private var tripNameSection: some View {
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
    
    private var tripDescriptionSection: some View {
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
    
    private var tripLocationSection: some View {
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
    
    private var tripDurationSection: some View {
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
                            detailManager.showRangeDatePicker = true
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

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}



