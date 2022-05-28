//
//  SectionBrandData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation

struct SectionBrandData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let brand: Brand
    let items: [Item]
}

