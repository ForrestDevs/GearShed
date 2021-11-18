//
//  DayOfMonthView.swift
//  CustomDatePickerApp
//
//  Created by Peter Ent on 11/2/20.
//

import SwiftUI

/**
 * MDPDayView displays the day of month on a MDPContentView. This a button whose color and
 * selectability is determined from the MDPDayOfMonth in the CustomDatePickerModel.
 */
struct MDPDayView: View {
    @EnvironmentObject var monthDataModel: CustomDatePickerModel
    let cellSize: CGFloat = 30
    var dayOfMonth: MDPDayOfMonth
    
    // outline "today"
    /*private var strokeColor: Color {
        dayOfMonth.isToday ? Color.accentColor : Color.clear
    }*/
    
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

struct DayOfMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MDPDayView(dayOfMonth: MDPDayOfMonth(index: 0, day: 1, date: Date(), isSelectable: true, isToday: false))
            .environmentObject(CustomDatePickerModel())
    }
}
