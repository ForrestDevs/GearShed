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



