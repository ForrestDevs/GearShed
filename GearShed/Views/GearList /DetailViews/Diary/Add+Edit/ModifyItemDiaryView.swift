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

    // MARK: Main Content
    var body: some View {
        NavigationView {
            contentView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButtonToolbarItem
                viewTitle
                saveButtonToolbarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    private var contentView: some View {
        ZStack {
            Color.theme.silver
                .ignoresSafeArea()
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 10) {
                    diaryItemSection
                    diaryDescriptionSection
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
    
    // MARK: Content Components
    private var diaryItemSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Item")
                    .formatEntryTitle()
                Text(editableData.item!.name)
                    .font(.subheadline)
                    .foregroundColor (Color.theme.accent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                    )
            }
        }
    }
    
    private var diaryDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Notes")
                    .formatEntryTitle()
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.theme.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                        )
                    if editableData.details.isEmpty {
                        Text("Gear Diary Notes")
                            .foregroundColor(Color.theme.promptText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    TextEditor(text: $editableData.details)
                        .padding(4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 500)
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

