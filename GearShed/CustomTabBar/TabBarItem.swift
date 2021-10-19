//
//  TabBarItem.swift
//  GearShedV1
//
//  Created by Luke Forrest Gannon on 2021-10-13.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    
    case shed, trips, home
    
    var iconName: String {
        switch self {
        case .shed: return "house"
        case .trips: return "figure.walk"
        case .home: return "list.bullet"
        }
    }
    
    var title: String {
        switch self {
        case .shed: return "My Shed"
        case .trips: return "My Trips"
        case .home: return "Home"
        }
    }
    
    var color: Color {
        switch self {
        case .shed: return Color.white
        case .trips: return Color.white
        case .home: return Color.white
        }
    }
    
}

