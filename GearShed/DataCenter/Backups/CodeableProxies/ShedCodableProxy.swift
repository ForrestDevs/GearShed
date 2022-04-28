//
//  ShedCodableProxy.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
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
        self.id = shed.id?.uuidString ?? ""
        self.name = shed.name
        shed.items.forEach({self.items.append($0.id?.uuidString ?? "")})
    }
}
