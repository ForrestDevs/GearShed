//
//  DayOfMonthView.swift
//  Gear Shed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct MDPDayView: View {
    @EnvironmentObject var monthDataModel: CustomDatePickerModel
    let cellSize: CGFloat = 30
    var dayOfMonth: MDPDayOfMonth
    
    // outline "first day"
    private var strokeColor: Color {
        if monthDataModel.selections.count == 1 {
            return monthDataModel.isSelected(dayOfMonth) ? Color.theme.accent : Color.clear
        } else {
            return Color.clear
        }
    }
    private var currentDayColor: Color {
        dayOfMonth.isToday ? Color.red : Color.theme.accent
    }
    // filled if selected
    private var fillColor: Color {
        if monthDataModel.selections.count == 1 {
            return Color.clear
        } else {
            return monthDataModel.isSelected(dayOfMonth) ? Color.theme.green.opacity(0.55) : Color.clear
        }
    }
    // reverse color for selections or gray if not selectable
    private var textColor: Color {
        if dayOfMonth.isToday {
            return Color.red
        } else {
            if dayOfMonth.isSelectable {
                return monthDataModel.isSelected(dayOfMonth) ? Color.theme.green : Color.theme.accent
            } else {
                return Color.gray
            }
        }
    }
    private func handleSelection() {
        if dayOfMonth.isSelectable {
            monthDataModel.selectDay(dayOfMonth)
        }
    }
    var body: some View {
        Button {
            handleSelection()
        } label: {
            Text("\(dayOfMonth.day)")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(textColor)
                .frame(minHeight: cellSize, maxHeight: cellSize)
                .background(
                    Circle()
                        .stroke(strokeColor, lineWidth: 1)
                        .background(Circle().foregroundColor(fillColor))
                        .frame(width: cellSize, height: cellSize)
                )
        }.foregroundColor(Color.theme.accent)
    }
}

/**
 * MDPDayView displays the day of month on a MDPContentView. This a button whose color and
 * selectability is determined from the MDPDayOfMonth in the CustomDatePickerModel.
 */
