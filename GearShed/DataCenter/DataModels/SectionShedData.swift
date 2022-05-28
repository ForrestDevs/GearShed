//
//  SectionShedData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-05-27.
//

import Foundation

struct SectionShedData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let shed: Shed
    let items: [Item]
}
