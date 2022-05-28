//
//  PersistantStore+StoreKit.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-24.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import StoreKit

extension PersistentStore {
    func appLaunched() {
        // Guard to only ask for review after x Items are created
        // Increase this number according to what the Pro Unlock number is
        // Only ask for review if a user has purchased the Pro Unlock
        guard count(for: Item.fetchRequest()) >= 5 else { return }
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
