//
//  DetailManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//

import SwiftUI

class DetailViewManager: ObservableObject {
    
    @Published var showGearlistDetail: Bool = false
    
    @Published var showAddNewGearlist: Bool = false
    
    @Published var showSelectGearlistItems: Bool = false
    
    @Published var showRangeDatePicker: Bool = false

    @Published var content: AnyView = AnyView(EmptyView())
    
    @Published var secondaryContent: AnyView = AnyView(EmptyView())
    
    init() {}
}
