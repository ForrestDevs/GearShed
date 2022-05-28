//
//  SectionTypeData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-05-27.
//

import Foundation

struct SectionTypeData: Identifiable, Hashable {
    var id: Int { hashValue }
    let title: String
    let type: ActivityType
    let activites: [Gearlist]
}
