//
//  BrandItemsViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//  Copyright © 2022 All rights reserved.
//

import Foundation

final class BrandItemsViewModel: ObservableObject {
    @Published var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    @Published var selectedBrand: Brand? = nil
    @Published var showingUnlockView: Bool = false
    @Published var isAddItemShowing: Bool = false
    @Published var isQuickAddItemShowing: Bool = false
    @Published var isAlertShowing: Bool = false
    @Published var newItemName: String = ""
    @Published var item1: Item? = nil
}
