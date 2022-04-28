//
//  GearShedViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//  Copyright © 2022 All rights reserved.
//

import Foundation

final class GearShedViewModel: ObservableObject {
    @Published var viewFilter: ViewFilter = .shed
    @Published var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    @Published var showAddItem: Bool = false
    @Published var showAddShed: Bool = false
    @Published var showAddBrand: Bool = false
    @Published var showAddWish: Bool = false
    @Published var currentSelection: Int = 0
    enum ViewFilter {
        case shed, brand, fav, regret, wish
    }
}
