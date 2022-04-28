//
//  Sequence+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension Sequence {
	// counts the number of elements that satisy a given boolean condition.  this
	// was originally included in Swift 5.0, but was later withdrawn "for performance
	// reasons," so i will keep it here until/if it comes back into the language
	func count(where selector: (Element) -> Bool) -> Int {
		reduce(0) { (sum, Element) -> Int in
			return selector(Element) ? sum + 1 : sum
		}
	}
}
