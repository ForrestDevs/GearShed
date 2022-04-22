//
//  GearlistCodeableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation

extension ActivityType: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ActivityTypeCodableProxy(from: self)
    }
}

extension Pile: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return PileCodableProxy(from: self)
    }
}
 
extension Pack: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return PackCodableProxy(from: self)
    }
}
 
extension PackingBool: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return PackingBoolCodableProxy(from: self)
    }
}
 
extension Gearlist: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return GearlistCodableProxy(from: self)
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
    
    init(from pile: Pile) {
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
    
    init(from pack: Pack) {
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
    
    init(from packingBool: PackingBool) {
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
        
        for pile in gearlist.piles {
            self.piles.append(pile.id!.uuidString)
        }
        
        for pack in gearlist.packs {
            self.packs.append(pack.id!.uuidString)
        }
        
        for packingBool in gearlist.packingBools {
            packingBools.append(packingBool.id!.uuidString)
        }
        
        for itemDiary in gearlist.diaries {
            self.itemDiaries.append(itemDiary.id!.uuidString)
        }
        
    }
}




