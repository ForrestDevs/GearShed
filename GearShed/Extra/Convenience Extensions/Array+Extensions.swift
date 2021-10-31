//
//  Array+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-31.
//

import Foundation

extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
