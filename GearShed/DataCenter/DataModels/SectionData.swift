//
//  SectionData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
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

// in a sectioned data display, one consisting of sections and with each section being
// itself a list, you usually work with a structure that looks like this:
//
// List {
//   ForEach(sections) { section in
//     Section(header: Text("title for this section")) {
//         ForEach(section.items) { item in
//         // display the item for this row in this section
//       }
//     }
//   }
// }
//
// so the notion of this struct is that we use it to say what to draw in each
// section: its title and an array of items to show in the section.  then, just
// rearrange your data as a [SectionData] and "plug it in" to the structure
// above.

