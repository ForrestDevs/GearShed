//
//  DetailManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//

import SwiftUI

class DetailViewManager: ObservableObject {
    
    // MARK: Generic Stuff
    
    @Published var content: AnyView = AnyView(EmptyView())
    @Published var secondaryContent: AnyView = AnyView(EmptyView())
    
    @Published var showContent: Bool = false
    @Published var showSecondaryContent: Bool = false
    
    // MARK: Gearshed Stuff
    
    @Published var selectedItem: Item? = nil 
    @Published var showAddItem: Bool = false
    @Published var showItemDetail: Bool = false
    @Published var showAddItemFromShed: Bool = false
    @Published var showAddItemFromBrand: Bool = false
    @Published var showModifyItem: Bool = false
    
    @Published var selectedShed: Shed? = nil
    @Published var showAddShed: Bool = false
    @Published var showAddShedFromItem: Bool = false
    @Published var showModifyShed: Bool = false
    
    @Published var selectedBrand: Brand? = nil
    @Published var showAddBrand: Bool = false
    @Published var showAddBrandFromItem: Bool = false
    @Published var showModifyBrand: Bool = false
    
    // MARK: Gearlist Stuff
    
    @Published var selectedGearlist: Gearlist? = nil
    @Published var showAddGearlist: Bool = false
    @Published var showAddItemsToGearlist: Bool = false
    @Published var showModifyGearlist: Bool = false
    @Published var showGearlistDetail: Bool = false
    
    @Published var selectedCluster: Cluster? = nil
    @Published var showAddCluster: Bool = false
    @Published var showModifyCluster: Bool = false
    
    @Published var selectedContainer: Container? = nil
    @Published var showAddContainer: Bool = false
    @Published var showModifyContainer: Bool = false
    
    init() {}
}
