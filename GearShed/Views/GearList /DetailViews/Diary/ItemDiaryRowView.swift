//
//  ItemDiaryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct ItemDiaryRowView: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @ObservedObject var diary: ItemDiary
    
    var body: some View {
        Button {
            detailManager.selectedItemDiary = diary
            withAnimation {
                detailManager.showItemDiaryDetail = true
            }
        } label: {
            HStack {
                VStack (alignment: .leading, spacing: 3) {
                    Text(diary.name)
                        .formatItemNameGreen()
                    Text(diary.details)
                        .formatItemDetailsGrey()
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.leading, 15)
        }
    }
}