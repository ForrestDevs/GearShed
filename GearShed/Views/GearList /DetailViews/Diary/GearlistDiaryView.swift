//
//  GearlistDiaryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-21.
//

import SwiftUI

struct GearlistDiaryView: View {
    @Environment(\.presentationMode) private var persentationMode
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var confirmDeleteDiaryAlert: ConfirmDeleteDiaryAlert?

    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .diary, gearlist: gearlist)
                if gearlist.diaries.count == 0 {
                    EmptyViewText(emptyText: "Diaries", buttonName: "Add Diary")
                } else {
                    diaryList
                }
            }
            addDiaryButtonOverlay
        }
        .alert(item: $confirmDeleteDiaryAlert) { diary in diary.alert() }
    }
    
    private var diaryList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(gearlist.diaries) { diary in
                    Section {
                        listContent(diary: diary)
                    } header: {
                        listHeader(diary: diary)
                    }
                }
            }
        }
    }
    
    private func listContent(diary: ItemDiary) -> some View {
        Text(diary.details)
            .lineLimit(1)
            .padding(.leading, 15)
            .contextMenu {
                editDiaryContext(diary: diary)
                deleteDiaryContext(diary: diary)
            }
    }
    
    private func editDiaryContext(diary: ItemDiary) -> some View {
        Button {
            detailManager.selectedItemDiary = diary
            withAnimation {
                detailManager.showModifyItemDiary = true
            }
        } label: {
            HStack {
                Text("Edit Diary")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private func deleteDiaryContext(diary: ItemDiary) -> some View {
        Button {
            confirmDeleteDiaryAlert = ConfirmDeleteDiaryAlert(persistentStore: persistentStore, diary: diary) {
                persentationMode.wrappedValue.dismiss()
            }
        } label: {
            HStack {
                Text("Delete Diary")
                Image(systemName: "trash")
            }
        }
    }
    
    private func listHeader(diary: ItemDiary) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(diary.item.name)
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
    
    private var addDiaryButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.showAddItemDiary = true
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Diary")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
            }
        }
    }
}

