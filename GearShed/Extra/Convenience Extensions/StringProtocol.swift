//
//  StringProtocol.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
