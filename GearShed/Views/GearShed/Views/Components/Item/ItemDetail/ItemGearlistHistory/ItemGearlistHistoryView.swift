//
//  ItemGearlistHistoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-04-27.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemGearlistHistoryView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ZStack {
                Color.theme.headerBG
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                HStack {
                    Text("Gearlist")
                        .formatItemDetailDiaryHeader()
                    Spacer()
                }
                .padding(.leading, 15)
            }
            ScrollView {
                LazyVStack (alignment: .leading, spacing: 0) {
                    ForEach(item.gearlists) { gearlist in
                        ItemGearlistHistoryRowView(gearlist: gearlist)
                    }
                }
            }
        }
    }
}
