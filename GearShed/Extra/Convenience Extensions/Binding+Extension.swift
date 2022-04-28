//
//  Binding+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-23.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
