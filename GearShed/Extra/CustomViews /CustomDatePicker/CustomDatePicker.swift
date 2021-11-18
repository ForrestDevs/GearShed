//
//  CustomDatePicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//

import SwiftUI

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
struct CustomDatePicker: View {
    
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
    
    @StateObject var monthModel: CustomDatePickerModel
       
    @EnvironmentObject var detailManager: DetailViewManager
    // selects only a single date
    
    init(singleDay: Binding<Date?>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: CustomDatePickerModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects any number of dates, non-contiguous
    
    init(anyDays: Binding<[Date]>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: CustomDatePickerModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects a closed date range
    
    init(dateRange: Binding<ClosedRange<Date>?>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: CustomDatePickerModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.0001)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        detailManager.showSecondaryContent = false
                    }
                }
            MDPMonthView()
                .environmentObject(monthModel)
        }
        .transition(.fly)
    }
}

extension AnyTransition {
    static var fly: AnyTransition { get {
        AnyTransition.modifier(active: FlyTransition(pct: 0), identity: FlyTransition(pct: 1))
        }
    }
}

struct FlyTransition: GeometryEffect {
    var pct: Double
    
    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {

        let rotationPercent = pct
        let a = CGFloat(Angle(degrees: 90 * (1-rotationPercent)).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(pct * 2), y: CGFloat(pct * 2)))
        
        if pct <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}
