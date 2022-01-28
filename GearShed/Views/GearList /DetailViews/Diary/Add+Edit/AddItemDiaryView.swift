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

    @State private var isEditing: Bool = false
    
    private var gearlist: Gearlist
    private var persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        self.persistentStore = persistentStore
        self.gearlist = gearlist
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableDiaryData(persistentStore: persistentStore, gearlist: gearlist)
        _editableData = State(initialValue: initialValue)
        
        UITextView.appearance().backgroundColor = .clear
    }
    
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
    
    // MARK: Main Content
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
                Menu {
                    ForEach(gearlist.items) { item in
                        Button {
                            editableData.item = item
                            if let item = editableData.item {
                                if item.hasExistingDiaryInGearlist(gearlist: gearlist, item: item) {
                                    editableData.details = item.gearlistDiaryDetails(gearlist: gearlist, item: item)
                                    isEditing = true
                                }
                            }
                        } label: {
                            HStack {
                                Text(item.name)
                                    .tag(item)
                                    .font(.subheadline)
                                if editableData.item == item {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                        }
                    }
                } label: {
                    Text(editableData.item?.name ?? "Select Item")
                        .font(.subheadline)
                        .foregroundColor (itemTextColor())
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
    
    private func itemTextColor() -> Color {
        var color: Color
        if editableData.item == nil {
            color = Color.theme.promptText
        } else {
            color = Color.theme.accent
        }
        return color
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("New Entry")
                .formatGreen()
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
                if isEditing {
                    viewModel.updateItemDiaryFromNewEntry(item: editableData.item!, gearlist: gearlist, details: editableData.details) 
                } else {
                    viewModel.addNewItemDiary(using: editableData)
                }
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
}

