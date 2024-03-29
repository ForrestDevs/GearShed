//
//  MonthYearPicker.swift
//  Gear Shed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct MDPMonthYearPicker: View {
    let months = (0...11).map {$0}
    let years = (1970...2099).map {$0}
    
    var date: Date
    var action: (Int, Int) -> Void
    
    @State private var selectedMonth = 0
    @State private var selectedYear = 2021
    
    init(date: Date, action: @escaping (Int, Int) -> Void) {
        self.date = date
        self.action = action
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        self._selectedMonth = State(initialValue: month - 1)
        self._selectedYear = State(initialValue: year)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .center, spacing: 0) {
                Picker("", selection: self.$selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text("\(Calendar.current.monthSymbols[month])").tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedMonth, perform: { value in
                    self.action(value + 1, self.selectedYear)
                })
                .frame(maxWidth: geometry.size.width / 2)
                .compositingGroup()
                .clipped()

                Picker("", selection: self.$selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(format: "%d", year)).tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedYear, perform: { value in
                    self.action(self.selectedMonth + 1, value)
                })
                .frame(maxWidth: geometry.size.width / 2)
                .compositingGroup()
                .clipped()
            }
        }
    }
}

/**
 * This is a two-wheel picker for selecting a month and a year. It appears when the user
 * taps on the month/year at the top of the MDMonthView.
 *
 * When a month or year is selected, the action parameter is invoked with the new values.
 */
