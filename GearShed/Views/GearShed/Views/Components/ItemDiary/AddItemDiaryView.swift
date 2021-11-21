//
//  AddItemDiaryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct AddItemDiaryView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @StateObject private var viewModel: GearShedData

    @State private var editableData: EditableDiaryData

    init(persistentStore: PersistentStore, gearlist: Gearlist, item: Item) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableDiaryData(persistentStore: persistentStore, gearlist: gearlist, item: item)
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
                cancelButtonToolbarItem
                viewTitle
                saveButtonToolbarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension AddItemDiaryView {
    
    // MARK: Main Content
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var contentLayer: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 10) {
                diaryNameSection
                diaryDescriptionSection
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    // MARK: Content Components
    private var diaryNameSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var diaryDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Notes")
                    .formatEntryTitle()

                TextField("", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
            }
        }
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showAddItemDiary = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("New Diary")
                .formatGreen()
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showAddItemDiary = false
                }
                viewModel.addNewItemDiary(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
    
}
