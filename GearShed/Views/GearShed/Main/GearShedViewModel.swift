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
    func itemWeightUnit(item: Item) -> String {
        var value: String = ""
        guard (item.weight == "0") || (item.itemLbs == "0" && item.itemOZ == "0.00") else { return value }
        
        if Prefs.shared.weightUnit == "g" {
            value = "\(item.weight) g"
        } else {
            let lbs = item.itemLbs
            let oz = item.itemOZ
            value = "\(lbs) Lbs \(oz) Oz"
        }
        return value
    }
    func itemWeightPriceText(item: Item) -> String {
        let itemWeightText = itemWeightUnit(item: item)
        let itemPriceText = item.price
        if itemWeightText.isEmpty && itemPriceText.isEmpty {
            return ""
        } else if itemPriceText.isEmpty && !itemWeightText.isEmpty {
            return "\(itemWeightText)"
        } else if itemWeightText.isEmpty && !itemPriceText.isEmpty {
            return "\(Prefs.shared.currencyUnitSetting) \(itemPriceText)"
        } else if !itemWeightText.isEmpty && !itemPriceText.isEmpty {
            return "\(itemWeightText) | \(Prefs.shared.currencyUnitSetting) \(itemPriceText)"
        } else {
            return ""
        }
    }
}
