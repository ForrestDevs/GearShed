//
//  TabBarManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-30.
//

import Foundation

/// An environment singleton responsible for managing the Tab Bar
final class TabBarManager: ObservableObject {
    private(set) static var shared = TabBarManager()
    @Published var hideTab: Bool = false
}
