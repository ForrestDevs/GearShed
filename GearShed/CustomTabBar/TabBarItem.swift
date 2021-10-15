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
    
    case shed, trips, settings
    
    var iconName: String {
        switch self {
        case .shed: return "house"
        case .trips: return "airplane"
        case .settings: return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .shed: return "Gear Shed"
        case .trips: return "My Trips"
        case .settings: return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        case .shed: return Color.green
        case .trips: return Color.green
        case .settings: return Color.green
        }
    }
    
}

