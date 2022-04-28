//
//  TabBarItem.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case gearshed, gearlist, settings
    var iconName: String {
        switch self {
            case .gearshed: return "house"
            case .gearlist: return "figure.walk"
            case .settings: return "gear"
        }
    }
    var title: String {
        switch self {
            case .gearshed: return "Gear Shed"
            case .gearlist: return "Gear Lists"
            case .settings: return "Settings"
        }
    }
}

