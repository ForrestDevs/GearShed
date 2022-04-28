//
//  GearlistDiaryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-21.
//  Copyright © 2022 All rights reserved.
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
                    EmptyViewText(text: "You have not created any diaries in this list. To create your first diary press the 'New Entry' button below.")
                } else {
                    diaryList
                }
            }
            addDiaryButtonOverlay
        }
        .alert(item: $confirmDeleteDiaryAlert) { diary in diary.alert() }
    }
    //MARK: Main Content
    private var diaryList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 10) {
                ForEach(gearlist.diaries) { diary in
                    diaryRow(diary: diary)
                }
            }
        }
    }
    private func diaryRow(diary: ItemDiary) -> some View {
        ZStack {
            Color.clear
            VStack (alignment: .leading, spacing: 3) {
                HStack (alignment: .firstTextBaseline, spacing: 5) {
                    HStack (spacing: 5) {
                        Text(diary.item?.name ?? "N/A")
                            .formatItemNameGreen()
                            .fixedSize()
                        if let item = diary.item {
                            statusIcon(item: item)
                        }
                    }
                    Text("|")
                        .formatItemNameBlack()
                    Text(diary.item?.brandName ?? "N/A")
                        .formatItemNameBlack()
                    Spacer()
                }
                .lineLimit(1)
                Text("''\(diary.details)''")
                    .formatDiaryDetails()
            }
            .padding(.horizontal, 15)
        }
        .contextMenu {
            editDiaryContext(diary: diary)
            deleteDiaryContext(diary: diary)
        }
    }
    private func statusIcon(item: Item) -> some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 2)
            } else
            if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.regretColor)
                    .padding(.horizontal, 2)
            } else
            if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.yellow)
                    .padding(.horizontal, 2)
            }
        }
    }
    //MARK: Context Buttons
    private func editDiaryContext(diary: ItemDiary) -> some View {
        Button {
            detailManager.selectedItemDiary = diary
            withAnimation {
                detailManager.secondaryTarget = .showModifyItemDiary
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
    private var addDiaryButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddItemDiary
                    }
                }
                label: {
                    VStack{
                        Text("New")
                        Text("Entry")
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
