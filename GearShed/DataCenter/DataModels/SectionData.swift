//
//  SectionData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - A Generic SectionData struct
struct SectionShedData: Identifiable, Hashable {
	var id: Int { hashValue }
	let title: String
    let shed: Shed
	let items: [Item]
}

struct SectionBrandData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let brand: Brand
    let items: [Item]
}

struct SectionTypeData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let type: ActivityType
    let activites: [Gearlist]
}

struct SectionYearData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let year: Int
    let adventures: [Gearlist]
}
