//
//  AllItemsViewModel.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-05.
//

import Foundation

final class ShedItemsViewModel: ObservableObject {
    @Published var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    @Published var selectedShed: Shed? = nil
    @Published var showingUnlockView: Bool = false
    @Published var isAddItemShowing: Bool = false
    @Published var isQuickAddItemShowing: Bool = false
    @Published var isAlertShowing: Bool = false
    @Published var newItemName: String = ""
    @Published var item1: Item? = nil
}



