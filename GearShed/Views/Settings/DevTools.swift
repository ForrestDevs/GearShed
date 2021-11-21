//
//  DevTools.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
import Foundation





final class BackupManager: ObservableObject {
    
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    enum FileName {
        case item, itemImg, itemDiary, shed, brand, gearlist, pile, pack, packBool, activityType
    }
    
    
    
    
    // and (2), knowing that Item, Shed and Brand are NSManagedObjects, and we
    // don't want to write our own custom encoder (eventually we will), we extend each to
    // be able to produce a simple, Codable struct proxy holding only what we want to write out
    // (ItemCodable, ShedCodable, and BrandCodeable structs, respectively)
    func writeAsJSON (items: [Item], itemImages: [ItemImage], itemDiaries: [ItemDiary], sheds: [Shed], brands: [Brand], gearlists: [Gearlist], piles: [Cluster], packs: [Container], packingBools: [ContainerBool], activityTypes: [ActivityType]) -> URL {
        
        var all = AllCodableProxy (
            items: [],
            itemImages: [],
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
        for itemImg in itemImages {
            let newItem = ItemImageCodableProxy(from: itemImg)
            all.itemImages.append(newItem)
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
            .appendingPathComponent("GearShed Backup")
            .appendingPathExtension("json")
        
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
    
    /*func writeAsJSON <T:CodableStructRepresentable> (items: [T], itemImages: [T], itemDiaries: [T], sheds: [T], brands: [T], gearlists: [T], piles: [T], packs: [T], packingBools: [T], activityTypes: [T]) -> URL {
        
        let all = AllCodableProxy (
            items: items.map() { $0.codableProxy as! AllCodableProxy.ItemCodableProxy } ,
            itemImages: itemImages.map() { $0.codableProxy as! AllCodableProxy.ItemImageCodableProxy },
            itemDiaries: itemDiaries.map() { $0.codableProxy as! AllCodableProxy.ItemDiaryCodableProxy },
            sheds: sheds.map() { $0.codableProxy as! AllCodableProxy.ShedCodableProxy },
            brands: brands.map() { $0.codableProxy as! AllCodableProxy.BrandCodableProxy },
            gearlists: gearlists.map() { $0.codableProxy as! AllCodableProxy.GearlistCodableProxy },
            piles: piles.map() { $0.codableProxy as! AllCodableProxy.PileCodableProxy },
            packs: packs.map() { $0.codableProxy as! AllCodableProxy.PackCodableProxy },
            packingBools: packingBools.map() { $0.codableProxy as! AllCodableProxy.PackingBoolCodableProxy },
            activityTypes: activityTypes.map() { $0.codableProxy as! AllCodableProxy.ActivityTypeCodableProxy }
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let documenDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documenDir
            .appendingPathComponent("GearShed Backup")
            .appendingPathExtension("json")
        
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
     }*/
    
    /*func writeAsJSON <T:CodableStructRepresentable> (items: [T], type: FileName) -> URL {
        var fileName: String = ""
        switch type {
        case .item:
            fileName = "ItemBackup"
        case .itemImg:
            fileName = "ItemImageBackup"
        case .itemDiary:
            fileName = "ItemDiaryBackup"
        case .shed:
            fileName = "ShedBackup"
        case .brand:
            fileName = "BrandBackup"
        case .gearlist:
            fileName = "GearlistBackup"
        case .pile:
            fileName = "PileBackup"
        case .pack:
            fileName = "PackBackup"
        case .packBool:
            fileName = "PackingBoolBackup"
        case .activityType:
            fileName = "ActivityTypeBackup"
        }
                
        let codableItems = items.map() { $0.codableProxy }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let documenDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documenDir
            .appendingPathComponent(fileName)
            .appendingPathExtension("json")
        
        var data = Data()
              
        do {
            data = try encoder.encode(codableItems)
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
    }*/
    
    /*func populateDatabaseFromJSON() {
        let codableSheds: [ShedCodableProxy] = Bundle.main.decode(from: kShedsFilename)
        insertNewSheds(from: codableSheds)
        let codableBrands: [BrandCodableProxy] = Bundle.main.decode(from: kBrandsFilename)
        insertNewBrands(from: codableBrands)
        let codableItems: [ItemCodableProxy] = Bundle.main.decode(from: kItemsFilename)
        insertNewItems(from: codableItems)
        persistentStore.saveContext()
    }
    
    
    func insertNewItems(from codableItems: [ItemCodableProxy]) {
        
        // get all Sheds that are not the unknown shed
        // group by name for lookup below when adding an item to a shed
        let sheds = Shed.allSheds(userShedsOnly: true)
        let name2Shed = Dictionary(grouping: sheds, by: { $0.name })
        
        // get all Brands that are not the unknown brand
        // group by name for lookup below when adding an item to a brand
        let brands = Brand.allBrands(userBrandsOnly: true)
        let name2Brand = Dictionary(grouping: brands, by: { $0.name })
        
        for codableItem in codableItems {
            let newItem = Item.addNewItem() // new UUID is created here
            newItem.name = codableItem.name
            newItem.quantity = codableItem.quantity
            newItem.weight = codableItem.weight
            newItem.price = codableItem.price
            newItem.wishlist = codableItem.wishlist
            newItem.isFavourite_ = codableItem.isFavourite
            //newItem.datePurchased_ = codableItem.datePurchased
            
            // look up matching shed by name
            // anything that doesn't match goes to the unknown shed.
            if let shed = name2Shed[codableItem.shedName]?.first {
                newItem.shed = shed
            } else {
                newItem.shed = Shed.unknownShed() // if necessary, this creates the Unknown Shed
            }
            
            // look up matching brand by name
            // anything that doesn't match goes to the unknown brand.
            if let brand = name2Brand[codableItem.brandName]?.first {
                newItem.brand = brand
            } else {
                newItem.brand = Brand.unknownBrand() // if necessary, this creates the Unknown Brand
            }
            
        }
    }

    // used to insert data from JSON files in the app bundle
    func insertNewSheds(from codableSheds: [ShedCodableProxy]) {
        for codableShed in codableSheds {
            let newShed = Shed.addNewShed() // new UUID created here
            newShed.name = codableShed.name
        }
    }

    // used to insert data from JSON files in the app bundle
    func insertNewBrands(from codableBrands: [BrandCodableProxy]) {
        for codableBrand in codableBrands {
            let newBrand = Brand.addNewBrand() // new UUID created here
            newBrand.name = codableBrand.name
        }
    }*/
    
    
    
    
}

import UniformTypeIdentifiers
import SwiftUI

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

/*struct JSONFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.text]

    // by default our document is empty
    var text = Data()

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
}*/


















