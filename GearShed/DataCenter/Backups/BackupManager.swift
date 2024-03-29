//
//  BackupManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

final class BackupManager: ObservableObject {
    let persistentStore: PersistentStore
    var resultHandler: ((Result<Bool, Error>) -> Void)?
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    enum FileName {
        case item, itemImg, itemDiary, shed, brand, gearlist, pile, pack, packBool, activityType
    }
    func decode<T: Decodable>(from url: URL) -> T {
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load backup")
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode backup due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode backup due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode backup due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode backup because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode backup: \(error.localizedDescription)")
        }
    }
    func writeAsJSON (items: [Item], itemDiaries: [ItemDiary], sheds: [Shed], brands: [Brand], gearlists: [Gearlist], piles: [Pile], packs: [Pack], packingBools: [PackingBool], activityTypes: [ActivityType]) -> URL {
        var all = AllCodableProxy (
            items: [],
            itemDiaries: [],
            sheds: [],
            brands: [],
            gearlists: [],
            piles: [],
            packs: [],
            packingBools: [],
            activityTypes: []
        )
        for item in items {
            let newItem = ItemCodableProxy(from: item)
            all.items.append(newItem)
        }
        for itemDiary in itemDiaries {
            let newItem = ItemDiaryCodableProxy(from: itemDiary)
            all.itemDiaries.append(newItem)
        }
        for shed in sheds {
            let newItem = ShedCodableProxy(from: shed)
            all.sheds.append(newItem)
        }
        for brand in brands {
            let newItem = BrandCodableProxy(from: brand)
            all.brands.append(newItem)
        }
        for gearlist in gearlists {
            let newItem = GearlistCodableProxy(from: gearlist)
            all.gearlists.append(newItem)
        }
        for pile in piles {
            let newItem = PileCodableProxy(from: pile)
            all.piles.append(newItem)
        }
        for pack in packs {
            let newItem = PackCodableProxy(from: pack)
            all.packs.append(newItem)
        }
        for bool in packingBools {
            let newItem = PackingBoolCodableProxy(from: bool)
            all.packingBools.append(newItem)
        }
        for type in activityTypes {
            let newItem = ActivityTypeCodableProxy(from: type)
            all.activityTypes.append(newItem)
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let documenDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documenDir
            .appendingPathComponent("GearShed Backup - \(Date().monthDayYearDateText())")
            .appendingPathExtension("gsb")
        var data = Data()
        do {
            data = try encoder.encode(all)
        } catch let error as NSError {
            print("Error converting items to JSON: \(error.localizedDescription), \(error.userInfo)")
        }
        do {
            try data.write(to: url)
        } catch let error as NSError {
            print("Could not write to desktop file: \(error.localizedDescription), \(error.userInfo)")
            print(String(data: data, encoding: .utf8)!)
        }
        return url
    }
    
    func backupToiCloudDrive(items: [Item], itemDiaries: [ItemDiary], sheds: [Shed], brands: [Brand], gearlists: [Gearlist], piles: [Pile], packs: [Pack], packingBools: [PackingBool], activityTypes: [ActivityType], completion: (Result<Bool, Error>) -> Void) {
        
        var all = AllCodableProxy (
            items: [],
            itemDiaries: [],
            sheds: [],
            brands: [],
            gearlists: [],
            piles: [],
            packs: [],
            packingBools: [],
            activityTypes: []
        )
        for item in items {
            let newItem = ItemCodableProxy(from: item)
            all.items.append(newItem)
        }
        for itemDiary in itemDiaries {
            let newItem = ItemDiaryCodableProxy(from: itemDiary)
            all.itemDiaries.append(newItem)
        }
        for shed in sheds {
            let newItem = ShedCodableProxy(from: shed)
            all.sheds.append(newItem)
        }
        for brand in brands {
            let newItem = BrandCodableProxy(from: brand)
            all.brands.append(newItem)
        }
        for gearlist in gearlists {
            let newItem = GearlistCodableProxy(from: gearlist)
            all.gearlists.append(newItem)
        }
        for pile in piles {
            let newItem = PileCodableProxy(from: pile)
            all.piles.append(newItem)
        }
        for pack in packs {
            let newItem = PackCodableProxy(from: pack)
            all.packs.append(newItem)
        }
        for bool in packingBools {
            let newItem = PackingBoolCodableProxy(from: bool)
            all.packingBools.append(newItem)
        }
        for type in activityTypes {
            let newItem = ActivityTypeCodableProxy(from: type)
            all.activityTypes.append(newItem)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        
        guard driveURL != nil else { return } 
        
        let backupURL = driveURL!
            .appendingPathComponent("GearShed Backup - \(Date().monthDayYearDateText())")
            .appendingPathExtension("gsb")
    
        var data = Data()
              
        do {
            data = try encoder.encode(all)
        } catch let error as NSError {
            print("Error converting items to JSON: \(error.localizedDescription), \(error.userInfo)")
            completion(.failure(error))
        }
        
        do {
            try data.write(to: backupURL)
            completion(.success(true))
        } catch let error as NSError {
            print("Could not write to desktop file: \(error.localizedDescription), \(error.userInfo)")
            print(String(data: data, encoding: .utf8)!)
            completion(.failure(error))
        }
    }
    func insertISBFromBackUp(url: URL) {
        let codable: AllCodableProxy = decode(from: url)
        let items = codable.items
        let sheds = codable.sheds
        let brands = codable.brands
        for item in items {
            let newItem = Item(context: persistentStore.context)
            newItem.id = UUID(uuidString: item.id)
            newItem.name = item.name
            newItem.detail = item.details
            newItem.price = item.price
            newItem.weight = item.weight
            newItem.isFavourite = item.isFavourite
            newItem.isWishlist = item.isWishlist
            newItem.isRegret = item.isRegret
        }
        for shed in sheds {
            let newShed = Shed(context: persistentStore.context)
            newShed.id = UUID(uuidString: shed.id)
            newShed.name = shed.name
            for item in shed.items {
                let newitem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newShed.addToItems_(newitem)
            }
        }
        for brand in brands {
            let newBrand = Brand(context: persistentStore.context)
            newBrand.id = UUID(uuidString: brand.id)
            newBrand.name = brand.name
            for item in brand.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newBrand.addToItems_(newItem)
            }
        }
        persistentStore.saveContext()
    }
    func insertBaseFromBackup(url: URL) {
        let codable: AllCodableProxy = decode(from: url)
        let items = codable.items
        let itemDiaries = codable.itemDiaries
        let sheds = codable.sheds
        let brands = codable.brands
        let gearlists = codable.gearlists
        let activityTypes = codable.activityTypes
        print("Begin Importing Items for Base Import")
        for item in items {
            guard (Item.object(id: UUID(uuidString: item.id)!, context: persistentStore.context) == nil) else {
                print("Item - \(item.name) already exists")
                continue
            }
            let newItem = Item(context: persistentStore.context)
            newItem.id = UUID(uuidString: item.id)
            newItem.name = item.name
            newItem.detail = item.details
            newItem.price = item.price
            newItem.weight = item.weight
            newItem.itemLbs = item.lbs
            newItem.itemOZ = item.oz
            newItem.isFavourite = item.isFavourite
            newItem.isWishlist = item.isWishlist
            newItem.isRegret = item.isRegret
            if let dateString = item.datePurchased {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                if let datePurchased = dateFormatter.date(from: dateString) {
                    newItem.datePurchased = datePurchased
                }
            }
            print("Successfully Imported \(newItem.name)")
        }
        print("Begin Importing Sheds for Base Import")
        for shed in sheds {
            guard (Shed.object(id: UUID(uuidString: shed.id)!, context: persistentStore.context) == nil) else {
                print("Shed - \(shed.name) already exists")
                continue
            }
            let newShed = Shed(context: persistentStore.context)
            newShed.id = UUID(uuidString: shed.id)
            newShed.name = shed.name
            for item in shed.items {
                let newitem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newShed.addToItems_(newitem)
            }
            print("Successfully Imported \(newShed.name)")
        }
        print("Begin Importing Brands for Base Import")
        for brand in brands {
            guard (Brand.object(id: UUID(uuidString: brand.id)!, context: persistentStore.context) == nil) else {
                print("Brand - \(brand.name) already exists")
                continue
            }
            let newBrand = Brand(context: persistentStore.context)
            newBrand.id = UUID(uuidString: brand.id)
            newBrand.name = brand.name
            for item in brand.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newBrand.addToItems_(newItem)
            }
            print("Successfully Imported \(newBrand.name)")
        }
        print("Begin Importing Gearlists for Base Import")
        for gearlist in gearlists {
            guard (Gearlist.object(id: UUID(uuidString: gearlist.id)!, context: persistentStore.context) == nil) else {
                print("Gearlist - \(gearlist.name) already exists")
                continue
            }
            let newGearlist = Gearlist(context: persistentStore.context)
            newGearlist.id = UUID(uuidString: gearlist.id)
            newGearlist.name = gearlist.name
            newGearlist.details = gearlist.details
            newGearlist.isAdventure = gearlist.isAdventure
            newGearlist.isBucketlist = gearlist.isBucketlist
            if let location = gearlist.location {
                newGearlist.location = location
            }
            if let country = gearlist.country {
                newGearlist.country = country
            }
            if let startDateString = gearlist.startDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                newGearlist.startDate = dateFormatter.date(from: startDateString)
            }
            if let endDateString = gearlist.endDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                newGearlist.endDate = dateFormatter.date(from: endDateString)
            }
            for item in gearlist.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newGearlist.addToItems_(newItem)
                print("Successfully added \(Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!.name) to Gearlist - \(gearlist.name)")
            }
            print("Successfully Imported \(gearlist.name)")
        }
        print("Begin Importing ActivityTypes for Base Import")
        for type in activityTypes {
            guard (ActivityType.object(id: UUID(uuidString: type.id)!, context: persistentStore.context) == nil) else {
                print("Type - \(type.name) already exists")
                continue
            }
            let newType = ActivityType(context: persistentStore.context)
            newType.id = UUID(uuidString: type.id)
            newType.name = type.name
            for gearlist in type.gearlists {
                let newGearlist = Gearlist.object(id: UUID(uuidString: gearlist)!, context: persistentStore.context)!
                newType.addToGearlists_(newGearlist)
            }
        }
        print("Begin Importing Item Diaries for Base Import")
        for itemDiary in itemDiaries {
            guard (ItemDiary.object(id: UUID(uuidString: itemDiary.id)!, context: persistentStore.context) == nil) else {
                print("ItemDiary - \(itemDiary.name) already exists")
                continue
            }
            let newItemDiary = ItemDiary(context: persistentStore.context)
            newItemDiary.id = UUID(uuidString: itemDiary.id)
            newItemDiary.name = itemDiary.name
            newItemDiary.details = itemDiary.details
            newItemDiary.item = Item.object(id: UUID(uuidString: itemDiary.item)!, context: persistentStore.context)!
            newItemDiary.gearlist = Gearlist.object(id: UUID(uuidString: itemDiary.gearlist)!, context: persistentStore.context)!
        }
        persistentStore.saveContext()
        
    }
    
    
    func insertFromBackup(url: URL) {
        let codable: AllCodableProxy = decode(from: url)
        let items = codable.items
        let itemDiaries = codable.itemDiaries
        let sheds = codable.sheds
        let brands = codable.brands
        let gearlists = codable.gearlists
        let piles = codable.piles
        let packs = codable.packs
        let packingBools = codable.packingBools
        let activityTypes = codable.activityTypes
        print("Begin Importing Items")
        for item in items {
            guard (Item.object(id: UUID(uuidString: item.id)!, context: persistentStore.context) == nil) else {
                print("Item - \(item.name) already exists")
                continue
            }
            let newItem = Item(context: persistentStore.context)
            newItem.id = UUID(uuidString: item.id)
            newItem.name = item.name
            newItem.detail = item.details
            newItem.price = item.price
            newItem.weight = item.weight
            newItem.itemLbs = item.lbs
            newItem.itemOZ = item.oz
            newItem.isFavourite = item.isFavourite
            newItem.isWishlist = item.isWishlist
            newItem.isRegret = item.isRegret
            if let dateString = item.datePurchased {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                if let datePurchased = dateFormatter.date(from: dateString) {
                    newItem.datePurchased = datePurchased
                }
            }
            print("Successfully Imported \(newItem.name)")
        }
        print("Begin Importing Sheds")
        for shed in sheds {
            guard (Shed.object(id: UUID(uuidString: shed.id)!, context: persistentStore.context) == nil) else {
                print("Shed - \(shed.name) already exists")
                continue
            }
            let newShed = Shed(context: persistentStore.context)
            newShed.id = UUID(uuidString: shed.id)
            newShed.name = shed.name
            for item in shed.items {
                let newitem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newShed.addToItems_(newitem)
            }
            print("Successfully Imported \(newShed.name)")
        }
        print("Begin Importing Brands")
        for brand in brands {
            guard (Brand.object(id: UUID(uuidString: brand.id)!, context: persistentStore.context) == nil) else {
                print("Brand - \(brand.name) already exists")
                continue
            }
            let newBrand = Brand(context: persistentStore.context)
            newBrand.id = UUID(uuidString: brand.id)
            newBrand.name = brand.name
            for item in brand.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newBrand.addToItems_(newItem)
            }
            print("Successfully Imported \(newBrand.name)")
        }
        print("Begin Importing Gearlists")
        for gearlist in gearlists {
            guard (Gearlist.object(id: UUID(uuidString: gearlist.id)!, context: persistentStore.context) == nil) else {
                print("Gearlist - \(gearlist.name) already exists")
                continue
            }
            let newGearlist = Gearlist(context: persistentStore.context)
            newGearlist.id = UUID(uuidString: gearlist.id)
            newGearlist.name = gearlist.name
            newGearlist.details = gearlist.details
            newGearlist.isAdventure = gearlist.isAdventure
            newGearlist.isBucketlist = gearlist.isBucketlist
            if let location = gearlist.location {
                newGearlist.location = location
            }
            if let country = gearlist.country {
                newGearlist.country = country
            }
            if let startDateString = gearlist.startDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                newGearlist.startDate = dateFormatter.date(from: startDateString)
            }
            if let endDateString = gearlist.endDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                newGearlist.endDate = dateFormatter.date(from: endDateString)
            }
            for item in gearlist.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newGearlist.addToItems_(newItem)
                print("Successfully added \(Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!.name) to Gearlist - \(gearlist.name)")
            }
            print("Successfully Imported \(gearlist.name)")
        }
        print("Begin Importing Piles")
        for pile in piles {
            guard (Pile.object(id: UUID(uuidString: pile.id)!, context: persistentStore.context) == nil) else {
                print("Pile - \(pile.name) already exists")
                continue
            }
            let newPile = Pile(context: persistentStore.context)
            newPile.id = UUID(uuidString: pile.id)
            newPile.name = pile.name
            newPile.gearlist = Gearlist.object(id: UUID(uuidString: pile.gearlist)!, context: persistentStore.context)!
            print("Successfully added new pile - \(pile.name)")
            print("Begin adding Items to Pile")
            for item in pile.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                newPile.addToItems_(newItem)
                print("Successfully added \(Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!.name) to Pile - \(pile.name)")
            }
        }
        print("Being Importing packs")
        for pack in packs {
            guard (Pack.object(id: UUID(uuidString: pack.id)!, context: persistentStore.context) == nil) else {
                print("Pack - \(pack.name) already exists")
                continue
            }
            let newPack = Pack(context: persistentStore.context)
            newPack.id = UUID(uuidString: pack.id)
            newPack.name = pack.name
            newPack.gearlist = Gearlist.object(id: UUID(uuidString: pack.gearlist)!, context: persistentStore.context)!
            for item in pack.items {
                let newItem = Item.object(id: UUID(uuidString: item)!, context: persistentStore.context)!
                
                let newPackBool = PackingBool(context: persistentStore.context)
                newPackBool.id = UUID()
                newPackBool.isPacked = false
                newPackBool.gearlist = Gearlist.object(id: UUID(uuidString: pack.gearlist)!, context: persistentStore.context)!
                newPackBool.pack = newPack
                newPackBool.item = newItem
                
                newPack.addToItems_(newItem)
            }
            print("Succesfully Imported Pack")
        }
        print("Begin Importing packingBools")
        for packingBool in packingBools {
            guard (PackingBool.object(id: UUID(uuidString: packingBool.id)!, context: persistentStore.context) == nil) else {
                print("Packing Bool - \(packingBool.id) already exists")
                continue
            }
            let newPackingBool = PackingBool(context: persistentStore.context)
            newPackingBool.id = UUID(uuidString: packingBool.id)
            newPackingBool.isPacked = packingBool.isPacked
            newPackingBool.gearlist = Gearlist.object(id: UUID(uuidString: packingBool.gearlist)!, context: persistentStore.context)!
            newPackingBool.item = Item.object(id: UUID(uuidString: packingBool.item)!, context: persistentStore.context)!
            newPackingBool.pack = Pack.object(id: UUID(uuidString: packingBool.pack)!, context: persistentStore.context)!
            
            // Should be adding to item gearlist and pack relationship here
            // newPackingBool.addToItem_()
            
        }
        print("Begin Importing ActivityTypes")
        for type in activityTypes {
            guard (ActivityType.object(id: UUID(uuidString: type.id)!, context: persistentStore.context) == nil) else {
                print("Type - \(type.name) already exists")
                continue
            }
            let newType = ActivityType(context: persistentStore.context)
            newType.id = UUID(uuidString: type.id)
            newType.name = type.name
            for gearlist in type.gearlists {
                let newGearlist = Gearlist.object(id: UUID(uuidString: gearlist)!, context: persistentStore.context)!
                newType.addToGearlists_(newGearlist)
            }
        }
        print("Begin Importing Item Diaries")
        for itemDiary in itemDiaries {
            guard (ItemDiary.object(id: UUID(uuidString: itemDiary.id)!, context: persistentStore.context) == nil) else {
                print("ItemDiary - \(itemDiary.name) already exists")
                continue
            }
            let newItemDiary = ItemDiary(context: persistentStore.context)
            newItemDiary.id = UUID(uuidString: itemDiary.id)
            newItemDiary.name = itemDiary.name
            newItemDiary.details = itemDiary.details
            newItemDiary.item = Item.object(id: UUID(uuidString: itemDiary.item)!, context: persistentStore.context)!
            newItemDiary.gearlist = Gearlist.object(id: UUID(uuidString: itemDiary.gearlist)!, context: persistentStore.context)!
        }
        persistentStore.saveContext()
    }
}

struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.text]
    // by default our document is empty
    var text = ""
    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}




