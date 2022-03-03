//
//  ProductView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon 
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
                Image(systemName: "infinity.circle")
                    .resizable()
                    .foregroundColor(Color.theme.green)
                    .frame(width: 50, height: 50)
                
                Text("Upgrade to Gear Shed Unlimited!")
                    .formatBlackTitle()
                
                Text("With the free version, you can add up to 30 pieces of gear and create one gearlist.")
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text("Purchase Gear Shed Unlimited To Get: ")
                        .bold()
                    
                    HStack {
                        Image(systemName: "internaldrive")
                        Text("Unlimited Size Data Base")
                    }
                    
                    HStack {
                        Image(systemName: "magazine")
                        Text("Unlimited Number of Gearlists")
                    }
                    
                    HStack {
                        Image(systemName: "arrow.clockwise.icloud")
                        Text("iCloud Drive Backups")
                    }
                    
                    HStack {
                        Image(systemName: "app.gift")
                        Text("Alternate App Icons")
                    }
                    
                    Text("Purchase Gear Shed Unlimited for \(product.localizedPrice) to gain the ability to add as much gear as you like, create unlimited gear lists, save backup files right to your iCloud Drive, as well as alternate app icons, to customize your Gear Shed.")
                    
                    Text("By spending what you would on two coffees you are supporting the devloper and helping to encourage future updates and new features. Your feedback is always welcomed.")
                    
                    Text("If you already bought this upgrade on another device, please press Restore Purchases below.")
                }
                HStack {
                    Button {
                        unlock()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 140, height: 55)
                                .foregroundColor(Color.theme.green)
                                .opacity(0.5)
                            HStack {
                                Image(systemName: "cart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .scaledToFit()
                                Text("Buy: \(product.localizedPrice)")
                            }
                        }
                    }
                    
                    Button {
                        restore()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 200, height: 55)
                                .foregroundColor(Color.theme.green)
                                .opacity(0.5)
                            HStack {
                                Image(systemName: "purchased")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .scaledToFit()
                                Text("Restore Purchases")
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
    
    func restore() {
        unlockManager.restore()
    }
}
