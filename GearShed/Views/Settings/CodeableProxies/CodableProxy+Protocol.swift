//
//  CodableProxy+Protocol.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation


// to write stuff out - Core Data Objects -
// the code is essentially the same except for the typing of the objects
// in the list.  so we use the power of generics:  we introduce
// (1) a protocol that demands that something be able to produce a simple
// Codable (struct) representation of itself -- a proxy as it were.
protocol CodableStructRepresentable {
    associatedtype DataType: Codable
    var codableProxy: DataType { get }
}

/*struct AllCodableProxy: Codable {
    
    //init<T:CodableStructRepresentable>(items: [T], itemImages: [T], itemDiaries: [T], sheds: [T], brands: [T], gearlists: [T], piles: [T], packs: [T], packingBools: [T], activityTypes: [T]) {

    init<T:CodableStructRepresentable>(from items: [T], from itemImages: [T], from itemDiaries: [T], from sheds: [T], from brands: [T], from gearlists: [T], from piles: [T], from packs: [T], from packingBools: [T], from activityTypes: [T]) {
        let test = items.m
        let codableItems = items.map() { $0.codableProxy }
        self.items = codableItems
        
        let codableItemImages = itemImages.map() { $0.codableProxy }
        self.itemImages = codableItemImages
        
        let codableItemDiaries = itemDiaries.map() { $0.codableProxy }
        self.itemDiaries = codableItemDiaries
        
        let codableSheds = sheds.map() { $0.codableProxy }
        self.sheds = codableSheds
        
        let codableBrands = brands.map() { $0.codableProxy }
        self.brands = codableBrands
        
        let codableGearlists = gearlists.map() { $0.codableProxy }
        self.gearlists = codableGearlists
        
        let codablePiles = piles.map() { $0.codableProxy }
        self.piles = codablePiles
        
        let codablePacks = packs.map() { $0.codableProxy }
        self.packs = codablePacks
        
        let codablePackingBools = packingBools.map() { $0.codableProxy }
        self.packingBools = codablePackingBools
        
        let codableActivityTypes = activityTypes.map() { $0.codableProxy }
        self.activityTypes = codableActivityTypes
    }
    
    var items: [ItemCodableProxy]
    var itemImages: [Any]
    var itemDiaries: [Any]
    var sheds: [Any]
    var brands: [Any]
    var gearlists: [Any]
    var piles: [Any]
    var packs: [Any]
    var packingBools: [Any]
    var activityTypes: [Any]
    
    /* var itemImages: [ItemImageCodableProxy]()
     var itemDiaries = [ItemDiaryCodableProxy]()
     var sheds = [ShedCodableProxy]()
     var brands = [BrandCodableProxy]()
     var gearlists = [GearlistCodableProxy]()
     var piles = [PileCodableProxy]()
     var packs = [PackCodableProxy]()
     var packingBools = [PackingBoolCodableProxy]()
     var activityTypes = [ActivityTypeCodableProxy]()*/
}*/

struct AllCodableProxy: Codable {
    var items: [ItemCodableProxy]
    var itemImages: [ItemImageCodableProxy]
    var itemDiaries: [ItemDiaryCodableProxy]
    var sheds: [ShedCodableProxy]
    var brands: [BrandCodableProxy]
    var gearlists: [GearlistCodableProxy]
    var piles: [PileCodableProxy]
    var packs: [PackCodableProxy]
    var packingBools: [PackingBoolCodableProxy]
    var activityTypes: [ActivityTypeCodableProxy]
}

/*  struct ItemCodableProxy: Codable {
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
     self.price = item.price
     
     self.shed = item.shed.id!.uuidString
     self.brand = item.brand.id!.uuidString
     
     for gearlist in item.gearlists {
         self.gearlists.append(gearlist.id!.uuidString)
     }
     
     for pile in item.clusters {
         self.piles.append(pile.id!.uuidString)
     }
     
     for pack in item.containers {
         self.packs.append(pack.id!.uuidString)
     }
     
     for packingBool in item.containerBools {
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
     self.item = diary.item.id!.uuidString
     self.gearlist = diary.gearlist.id!.uuidString
 }
}

struct ItemImageCodableProxy: Codable {
 var id: String
 var imgData: String
 var item: String
 
 init(from itemImg: ItemImage) {
     self.id = itemImg.id!.uuidString
     self.imgData = itemImg.img.base64EncodedString()
     self.item = itemImg.item.id!.uuidString
 }
}

struct ShedCodableProxy: Codable {
 var id: String
 var name: String
 var items = [String]()

 init(from shed: Shed) {
     self.id = shed.id!.uuidString
     self.name = shed.name
     
     for item in shed.items {
         self.items.append(item.id!.uuidString)
     }
 }
}

struct BrandCodableProxy: Codable {
 var id: String
 var name: String
 var items = [String]()

 init(from brand: Brand) {
     self.id = brand.id!.uuidString
     self.name = brand.name
     
     for item in brand.items {
         self.items.append(item.id!.uuidString)
     }
 }
}

struct ActivityTypeCodableProxy: Codable {
 var id: String
 var name: String
 var gearlists = [String]()
 
 init (from type: ActivityType) {
     self.id = type.id!.uuidString
     self.name = type.name
     
     for gearlist in type.gearlists {
         self.gearlists.append(gearlist.id!.uuidString)
     }
 }
}

struct PileCodableProxy: Codable {
 var id: String
 var name: String
 var gearlist: String
 var items = [String]()
 
 init(from pile: Cluster) {
     self.id = pile.id!.uuidString
     self.name = pile.name
     self.gearlist = pile.gearlist.id!.uuidString
     
     for item in pile.items {
         self.items.append(item.id!.uuidString)
     }
 }
}

struct PackCodableProxy: Codable {
 var id: String
 var name: String
 var gearlist: String
 var items = [String]()
 
 init(from pack: Container) {
     self.id = pack.id!.uuidString
     self.name = pack.name
     self.gearlist = pack.gearlist.id!.uuidString
     
     for item in pack.items {
         self.items.append(item.id!.uuidString)
     }
 }
 
}

struct PackingBoolCodableProxy: Codable {
 var id: String
 var isPacked: Bool
 var gearlist: String
 var item: String
 
 init(from packingBool: ContainerBool) {
     self.id = packingBool.id!.uuidString
     self.isPacked = packingBool.isPacked
     self.gearlist = packingBool.gearlist.id!.uuidString
     self.item = packingBool.item.id!.uuidString
 }
}

struct GearlistCodableProxy: Codable {
 
 var id: String
 var name: String
 var details: String
 var isAdventure: Bool
 var isBucketlist: Bool
 
 var startDate: String?
 var endDate: String?
 
 var location: String?
 var country: String?
 
 var activityType: String?
 
 var items = [String]()
 var piles = [String]()
 var packs = [String]()
 var packingBools = [String]()
 var itemDiaries = [String]()
 
 init(from gearlist: Gearlist) {
     self.id = gearlist.id!.uuidString
     self.name = gearlist.name
     self.details = gearlist.details
     
     self.isAdventure = gearlist.isAdventure
     self.isBucketlist = gearlist.isBucketlist
     
     if let startDate = gearlist.startDate {
         self.startDate = startDate.dateText(style: .full)
     }
 
     if let endDate = gearlist.endDate {
         self.endDate = endDate.dateText(style: .full)
     }
     
     if let location = gearlist.location {
         self.location = location
     }
     
     if let country = gearlist.country {
         self.country = country
     }
     
     if let type = gearlist.activityType {
         self.activityType = type.id!.uuidString
     }
     
     for item in gearlist.items {
         self.items.append(item.id!.uuidString)
     }
     
     for pile in gearlist.clusters {
         self.piles.append(pile.id!.uuidString)
     }
     
     for pack in gearlist.containers {
         self.packs.append(pack.id!.uuidString)
     }
     
     for packingBool in gearlist.containerBools {
         packingBools.append(packingBool.id!.uuidString)
     }
     
     for itemDiary in gearlist.diaries {
         self.itemDiaries.append(itemDiary.id!.uuidString)
     }
     
 }
}*/


