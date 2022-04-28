//
//  Date+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension Date {
	func dateText(style: DateFormatter.Style)-> String {
		// appeal to some nice formatting help
		let dateFormatter = DateFormatter()
		dateFormatter.doesRelativeDateFormatting = true
		dateFormatter.timeStyle = .none // just show date without specific time
		dateFormatter.dateStyle = style
		dateFormatter.locale = Locale.autoupdatingCurrent  // Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
    func monthDayYearDateText() -> String {
        let dateForm = DateFormatter()
        dateForm.timeStyle = .none
        dateForm.locale = Locale.autoupdatingCurrent
        dateForm.setLocalizedDateFormatFromTemplate("MMMM d y")
        return dateForm.string(from: self)
    }
    func hourMinuteText() -> String {
        let dateForm = DateFormatter()
        dateForm.dateStyle = .none
        dateForm.timeStyle = .short
        return dateForm.string(from: self)
    }
}

extension Date {
    // "2021-03-13T20:49:26.606Z"
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}

extension Date {
    func startDateYear() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        let year = components.year!
        return year
    }
}

