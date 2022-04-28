//
//  DayOfMonth.swift
//  Gear Shed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import Foundation

struct MDPDayOfMonth {
    // used to keep track of this DayOfMonth's position in its collection
    var index = 0
    // a day of zero (0) means that this day will appear blank and is unusable. otherwise this
    // is the actual calendar day of the month
    var day = 0
    // the real Date being represented by this struct. this value is created to make comparisons
    // faster.
    var date: Date? = nil
    // set to true if this DayOfMonth may be selected by the user
    var isSelectable = false
    // set to true only if this DayOfMonth represents the live, current, day
    var isToday = false
}

/**
 * Instances of this struct are created by the CustomDatePickerModel once a control date is set. This struct
 * represents one of 42 (7 days in a week, 6 possible weeks in a month) possible days. By
 * having the model build this struct at the outset, it reduces computations during runtime.
 */
