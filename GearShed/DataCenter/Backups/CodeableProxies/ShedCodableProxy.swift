//
//  ShedCodableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation

extension Shed: CodableStructRepresentable {
    var codableProxy: some Encodable & Decodable {
        return ShedCodableProxy(from: self)
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
