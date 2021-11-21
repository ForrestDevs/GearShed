//
//  ModifyItemDiaryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct ModifyItemDiaryView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager

    @State private var editableData: EditableDiaryData
        
    @StateObject private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore, diary: ItemDiary) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableDiaryData(persistentStore: persistentStore, diary: diary)
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

extension ModifyItemDiaryView {
    
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
                    detailManager.showModifyItemDiary = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Diary")
                .formatGreen()
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyItemDiary = false
                }
                viewModel.updateItemDiary(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
    
}
