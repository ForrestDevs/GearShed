//
//  ItemDiaryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemDiaryHistoryRowView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @ObservedObject var diary: ItemDiary
    
    var body: some View {
        Button {
            detailManager.selectedItemDiary = diary
            withAnimation {
                detailManager.secondaryTarget = .showItemDiaryDetail
            }
        } label: {
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(diary.gearlist.name)
                        .formatItemNameGreen()
                    Text("|")
                        .formatItemNameBlack()
                    Text(diary.gearlist.startDate?.monthDayYearDateText() ?? "")
                        .formatItemNameBlack()
                }
                
                
                Text("''\(diary.details)''")
                    .formatDiaryDetails()
                    .lineLimit(2)
            }
            .padding(.leading, 15)
        }
    }
}


