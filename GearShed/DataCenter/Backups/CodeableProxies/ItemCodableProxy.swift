//
//  ItemCodable.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension Item: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemCodableProxy(from: self)
    }
}

struct ItemCodableProxy: Codable {
    var id: String
    var name: String
    var details: String
    var datePurchased: String?
    var isWishlist: Bool
    var isFavourite: Bool
    var isRegret: Bool
    var quantity: Int
    var price: String
    var weight: String
    var lbs: String
    var oz: String
    var shed: String
    var brand: String
    var gearlists = [String]()
    var piles = [String]()
    var packs = [String]()
    var packingBools = [String]()
    var diaries = [String]()
    init(from item: Item) {
        self.id = item.id!.uuidString
        self.name = item.name
        self.details = item.detail
        if let date = item.datePurchased {
            self.datePurchased = date.dateText(style: .full)
        }
        self.isWishlist = item.isWishlist
        self.isFavourite = item.isFavourite
        self.isRegret = item.isRegret
        self.quantity = item.quantity
        self.weight = item.weight
        self.lbs = item.itemLbs
        self.oz = item.itemOZ
        self.price = item.price
        self.shed = item.shed.id!.uuidString
        self.brand = item.brand.id!.uuidString
        item.gearlists.forEach({self.gearlists.append($0.id?.uuidString ?? "")})
        item.piles.forEach({self.piles.append($0.id?.uuidString ?? "")})
        item.packs.forEach({self.packs.append($0.id?.uuidString ?? "")})
        item.packingBools.forEach({self.packingBools.append($0.id?.uuidString ?? "")})
        item.diaries.forEach({self.diaries.append($0.id?.uuidString ?? "")})
    }
}

extension ItemDiary: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemDiaryCodableProxy(from: self)
    }
}

struct ItemDiaryCodableProxy: Codable {
    var id: String
    var name: String
    var details: String
    var item: String
    var gearlist: String
    init(from diary: ItemDiary) {
        self.id = diary.id!.uuidString
        self.name = diary.name
        self.details = diary.details
        self.item = diary.item!.id!.uuidString
        self.gearlist = diary.gearlist.id!.uuidString
    }
}



