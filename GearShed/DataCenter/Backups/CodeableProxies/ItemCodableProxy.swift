//
//  ItemCodable.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation

extension Item: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemCodableProxy(from: self)
    }
}

extension ItemDiary: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemDiaryCodableProxy(from: self)
    }
}

extension ItemImage: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ItemImageCodableProxy(from: self)
    }
}

struct ItemCodableProxy: Codable {
    var id: String
    var name: String
    var details: String
    var img: String?
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
        
        if let img = item.image {
            self.img = img.id!.uuidString
        }
        
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
        
        for gearlist in item.gearlists {
            self.gearlists.append(gearlist.id!.uuidString)
        }
        
        for pile in item.piles {
            self.piles.append(pile.id!.uuidString)
        }
        
        for pack in item.packs {
            self.packs.append(pack.id!.uuidString)
        }
        
        for packingBool in item.packingBools {
            self.packingBools.append(packingBool.id!.uuidString)
        }
        
        for diary in item.diaries {
            diaries.append(diary.id!.uuidString)
        }
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

struct ItemImageCodableProxy: Codable {
    var id: String
    var imgURL: String
    var item: String
    
    init(from itemImg: ItemImage) {
        self.id = itemImg.id!.uuidString
        self.imgURL = String(describing: itemImg.imgURL)
        self.item = itemImg.item.id!.uuidString
    }
}




