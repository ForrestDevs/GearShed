//
//  BinaryInteger.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-17.
//  Copyright © 2022 All rights reserved.
//

import Foundation

extension BinaryInteger {
    ///Returns true whenever the integer is even, otherwise it will return false
    var isEven: Bool { return self % 2 == 0 }
    ///Returns true whenever the integer is odd, otherwise it will return false
    var isOdd: Bool { return self % 2 != 0 }
}
