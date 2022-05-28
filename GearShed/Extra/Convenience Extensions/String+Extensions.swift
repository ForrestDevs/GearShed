//
//  String+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension String {
	// this is useful in asking whether the searchText of the PurchasedItemsTabView
	// appears in item names; it makes use more straightforward
	func appearsIn(_ str: String) -> Bool {
		let cleanedSearchText = self.trimmingCharacters(in: .whitespacesAndNewlines)
		if cleanedSearchText.isEmpty {
			return true
		}
		return str.localizedCaseInsensitiveContains(cleanedSearchText)
	}
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var trimZero: String {
        if self == "0" {
            return self.replacingOccurrences(of: "0", with: "")
        } else if self == "0.00" {
            return self.replacingOccurrences(of: "0.00", with: "")
        } else {
            return self
        }
    }
    
    
    
    
}
