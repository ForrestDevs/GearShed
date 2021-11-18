//
//  GearShedViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//

import Foundation

final class GearShedViewModel: ObservableObject {
    
    enum ViewFilter {
        case shed, brand, fav, regret, wish
    }
    
    @Published var viewFilter: ViewFilter = .shed

    
    @Published var showPDFScreen: Bool = false

    @Published var showAddItem: Bool = false
    @Published var showAddShed: Bool = false
    @Published var showAddBrand: Bool = false
    @Published var showAddWish: Bool = false
}
