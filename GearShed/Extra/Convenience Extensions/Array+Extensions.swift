//
//  Array+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-31.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func slice(size: Int) -> [[Element]] {
        (0...(count / size)).map{Array(self[($0 * size)..<(Swift.min($0 * size + size, count))])}
    }
}





