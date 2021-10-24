//
//  Date+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
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
}
