//
//  GearlistCodeableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
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
        self.id = type.id?.uuidString ?? ""
        self.name = type.name
        type.gearlists.forEach({self.gearlists.append($0.id?.uuidString ?? "")})
    }
}

struct PileCodableProxy: Codable {
    var id: String
    var name: String
    var gearlist: String
    var items = [String]()
    init(from pile: Pile) {
        self.id = pile.id?.uuidString ?? ""
        self.name = pile.name
        self.gearlist = pile.gearlist.id?.uuidString ?? ""
        pile.items.forEach({self.items.append($0.id?.uuidString ?? "")})
    }
}

struct PackCodableProxy: Codable {
    var id: String
    var name: String
    var gearlist: String
    var items = [String]()
    init(from pack: Pack) {
        self.id = pack.id?.uuidString ?? ""
        self.name = pack.name
        self.gearlist = pack.gearlist.id?.uuidString ?? ""
        pack.items.forEach({self.items.append($0.id?.uuidString ?? "")})
    }
}

struct PackingBoolCodableProxy: Codable {
    var id: String
    var isPacked: Bool
    var gearlist: String
    var item: String
    init(from packingBool: PackingBool) {
        self.id = packingBool.id?.uuidString ?? ""
        self.isPacked = packingBool.isPacked
        self.gearlist = packingBool.gearlist.id?.uuidString ?? ""
        self.item = packingBool.item.id?.uuidString ?? ""
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
        self.id = gearlist.id?.uuidString ?? ""
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
        gearlist.items.forEach({self.items.append($0.id?.uuidString ?? "")})
        gearlist.piles.forEach({self.piles.append($0.id?.uuidString ?? "")})
        gearlist.packs.forEach({self.packs.append($0.id?.uuidString ?? "")})
        gearlist.packingBools.forEach({self.packingBools.append($0.id?.uuidString ?? "")})
        gearlist.diaries.forEach({self.itemDiaries.append($0.id?.uuidString ?? "")})
    }
}




