//
//  StringProtocol.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
