//
//  CodableProxy+Protocol.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import Foundation

protocol CodableStructRepresentable {
    associatedtype DataType: Codable
    var codableProxy: DataType { get }
}

struct AllCodableProxy: Codable {
    var items: [ItemCodableProxy]
    var itemDiaries: [ItemDiaryCodableProxy]
    var sheds: [ShedCodableProxy]
    var brands: [BrandCodableProxy]
    var gearlists: [GearlistCodableProxy]
    var piles: [PileCodableProxy]
    var packs: [PackCodableProxy]
    //var packingBools: [PackingBoolCodableProxy]
    var activityTypes: [ActivityTypeCodableProxy]
}



