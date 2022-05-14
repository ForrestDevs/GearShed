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


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

// Extending View for PageLabel and PageView Modifiers....
extension View {
    func pageLabel() -> some View {
        // Just Filling all Empty Space...
        self
        .frame(maxWidth: .infinity,alignment: .center)
    }
    // Modifications for SafeArea Ignoring...
    // Same For PageView...
    func pageView(ignoresSafeArea: Bool = false, edges: Edge.Set = [] ) -> some View {
        // Just Filling all Empty Space...
        self
            .frame(width: getScreenBounds().width,alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
    // Getting Screen Bounds...
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}


//extension View {
//    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
//        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
//    }
//}
//
