//
//  View+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI

// define a sectionHeader View modifier (to avoid iOS 14 ALL-CAPS style)
struct SectionHeader: ViewModifier {
	func body(content: Content) -> some View {
		content
			.textCase(.none)
	}
}

extension View {
	func sectionHeader() -> some View {
		modifier(SectionHeader())
	}
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension CGSize {
static func * (size: CGSize, value: CGFloat) -> CGSize {
    return CGSize(width: size.width * value, height: size.height * value)
   }
}
