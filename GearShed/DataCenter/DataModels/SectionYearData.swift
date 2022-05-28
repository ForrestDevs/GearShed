//
//  SectionYearData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-05-27.
//

import Foundation

struct SectionYearData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let year: Int
    let adventures: [Gearlist]
}
