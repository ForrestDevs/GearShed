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
        case .trips: return "airplane"
        case .home: return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .shed: return "Gear Shed"
        case .trips: return "My Trips"
        case .home: return "Home"
        }
    }
    
    var color: Color {
        switch self {
        case .shed: return Color.green
        case .trips: return Color.green
        case .home: return Color.green
        }
    }
    
}

