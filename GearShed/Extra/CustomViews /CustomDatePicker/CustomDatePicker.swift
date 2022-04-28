//
//  CustomDatePicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct CustomDatePicker: View {
    @EnvironmentObject var detailManager: DetailViewManager
    @StateObject var monthModel: CustomDatePickerModel
    // the type of picker, based on which init() function is used.
    enum PickerType {
        case singleDay
        case anyDays
        case dateRange
    }
    // lets all or some dates be elligible for selection.
    enum DateSelectionChoices {
        case allDays
        case weekendsOnly
        case weekdaysOnly
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.0001)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        detailManager.tertiaryTarget = .noView
                    }
                }
            MDPMonthView()
                .environmentObject(monthModel)
        }
        .transition(.fly)
    }
}

extension CustomDatePicker {
    /// Initializer for loading a Single Date Picker
    init(singleDay: Binding<Date?>, includeDays: DateSelectionChoices = .allDays, minDate: Date? = nil, maxDate: Date? = nil) {
        let model = CustomDatePickerModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate)
        _monthModel = StateObject(wrappedValue: model)
    }
    /// Initializer for loading an any number of Dates, non-contiguous, Picker.
    init(anyDays: Binding<[Date]>, includeDays: DateSelectionChoices = .allDays, minDate: Date? = nil, maxDate: Date? = nil) {
        let model = CustomDatePickerModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate)
        _monthModel = StateObject(wrappedValue: model)
    }
    /// Initializer for loading a Closed Date Range Picker.
    init(dateRange: Binding<ClosedRange<Date>?>, includeDays: DateSelectionChoices = .allDays, minDate: Date? = nil, maxDate: Date? = nil) {
        let model = CustomDatePickerModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate)
        _monthModel = StateObject(wrappedValue: model)
    }
}

/**
 * This component shows a date picker very similar to Apple's SwiftUI 2.0 DatePicker, but with a difference.
 * Instead of just allowing a single date to be picked, the CustomDatePicker also allows the user to select
 * a set of non-contiguous dates or a date range. It just depends on how this View is initialized.
 *
 * init(singleDay: Binding<Date> [,options])
 *      A single-date picker. Selecting a date de-selects the previous selection. Because the binding
 *      is a Date, there is always a selected date.
 *
 * init(anyDates: Binding<[Date]>, [,options])
 *      Allows multiple, non-continguous, dates to be selected. De-select a date by tapping it again.
 *      The binding array may be empty or it will be an array of dates selected in ascending order.
 *
 * init(dateRange: Binding<ClosedRange<Date>?>, [,options])
 *      Selects a date range. Tapping on a date marks it as the first date, tapping a second date
 *      completes the range. Tapping a date again resets the range. The binding will be nil unless
 *      two dates are selected, completeing the range.
 *
 * optional parameters to init() functions are:
 *  - includeDays: .allDays, .weekdaysOnly, .weekendsOnly
 *      Days not selectable are shown in gray and not selected.
 *  - minDate: Date? = nil
 *      Days before minDate are not selectable.
 *  - maxDate: Date? = nil
 *      Days after maxDate are not selectable.
 */

