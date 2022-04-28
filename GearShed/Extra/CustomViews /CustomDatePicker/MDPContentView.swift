//
//  CustomDatePicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct DPMonthView: View {
    @EnvironmentObject var monthDataModel: CustomDatePickerModel
    let cellSize: CGFloat = 30
    let columns = [
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2),
        GridItem(.fixed(30), spacing: 2)
    ]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            // Sun, Mon, etc.
            ForEach(0..<monthDataModel.dayNames.count, id: \.self) { index in
                Text(monthDataModel.dayNames[index].uppercased())
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.bottom, 10)
            // The actual days of the month.
            ForEach(0..<monthDataModel.days.count, id: \.self) { index in
                if monthDataModel.days[index].day == 0 {
                    Text("")
                        .frame(minHeight: cellSize, maxHeight: cellSize)
                } else {
                    MDPDayView(dayOfMonth: monthDataModel.days[index])
                }
            }
        }.padding(.bottom, 10)
    }
}
