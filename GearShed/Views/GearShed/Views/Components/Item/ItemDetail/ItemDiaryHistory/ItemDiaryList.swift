//
//  ItemDiaryList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemDiaryList: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ZStack {
                Color.theme.headerBG
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                HStack {
                    Text("Diary")
                        .formatItemDetailDiaryHeader()
                    Spacer()
                }
                .padding(.leading, 15)
            }
            ScrollView {
                LazyVStack (alignment: .leading, spacing: 0) {
                    ForEach(item.diaries) { diary in
                        ItemDiaryHistoryRowView(diary: diary)
                    }
                }
            }
        }
    }
}
