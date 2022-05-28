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
//    func itemPriceText(item: Item) -> String {
//        if item.price == "0" {
//            return ""
//        } else if item.price == "" {
//            return ""
//        } else {
//            return "\(Prefs.shared.currencyUnitSetting) \(item.price)"
//        }
//    }
//    
//    func itemWeightUnit(item: Item) -> String {
//        var value: String = ""
//        if Prefs.shared.weightUnit == "g" {
//            guard !(item.weight == "0" || item.weight == "") else { return value }
//            value = "\(item.weight) g"
//        } else if Prefs.shared.weightUnit == "lb + oz" {
//            let lbs = item.itemLbs
//            let oz = item.itemOZ
//            guard !(lbs == "0" && oz == "0.00" || lbs == "" && oz == "") else { return value }
//            if lbs == "0" || lbs == "" {
//                value = "\(oz) oz"
//            } else if oz == "0.00" || oz == "" {
//                value = "\(lbs) Lbs"
//            } else {
//                value = "\(lbs) Lbs \(oz) Oz"
//            }
//        }
//        return value
//    }
//    func itemWeightPriceText(item: Item) -> String {
//        let itemWeightText = itemWeightUnit(item: item)
//        let itemPriceText = itemPriceText(item: item)
//        if itemWeightText.isEmpty && itemPriceText.isEmpty {
//            return ""
//        } else if itemPriceText.isEmpty && !itemWeightText.isEmpty {
//            return itemWeightText
//        } else if itemWeightText.isEmpty && !itemPriceText.isEmpty {
//            return itemPriceText
//        } else if !itemWeightText.isEmpty && !itemPriceText.isEmpty {
//            return "\(itemWeightText) | \(itemPriceText)"
//        } else {
//            return ""
//        }
//    }
}
