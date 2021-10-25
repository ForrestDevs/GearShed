//
//  ProductView.swift
//  UltimatePortfolio
//
//  Created by Philipp on 04.07.21.
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Access")
                    .font(.headline)
                    .padding(.top, 10)

                Text("You can add five items for free, or pay \(product.localizedPrice) to add unlimited items.")
                Text("If you already bought the unlock on another device, press Restore Purchases.")

                Button("Buy: \(product.localizedPrice)", action: unlock)
                    //.buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    //.buttonStyle(PurchaseButton())
            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}

