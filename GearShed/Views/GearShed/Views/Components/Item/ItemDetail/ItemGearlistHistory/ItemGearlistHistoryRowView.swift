//
//  ItemGearlistHistoryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-04-27.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemGearlistHistoryRowView: View {
    @ObservedObject var gearlist: Gearlist
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(gearlist.name)
                    .formatItemNameGreen()
                    .lineLimit(1)
                    
                Text("|")
                    .formatItemNameBlack()
                Text(gearlist.startDate?.monthDayYearDateText() ?? "")
                    .formatItemNameBlack()
            }
            
            Text(gearlist.details)
                .formatDiaryDetails()
                .lineLimit(2)
        }
        .padding(.leading, 15)
    }
}
