//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

enum StatType {
    case shed, brand, fav, regret, wish, adventure, activity, list, pile, pack
}

struct StatBar: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var gsData: GearShedData
    
    @EnvironmentObject private var glData: GearlistData
    
    @State var statType: StatType
    
    @State var gearlist: Gearlist?
    
    var body: some View {
        HStack (spacing: 20) {
            switch statType {
            case .shed:
                HStack {
                    Text("Items:")
                    Text("\(gsData.items.count)")
                }
                HStack {
                    Text("Weight:")
                    Text("\(gsData.totalWeight(array: gsData.items))g")
                }
                HStack {
                    Text("Invested:")
                    Text("$\(gsData.totalCost(array: gsData.items))")
                }
            case .brand:
                HStack {
                    Text("Items:")
                    Text("\(gsData.items.count)")
                }
                HStack {
                    Text("Weight:")
                    Text("\(gsData.totalWeight(array: gsData.items))g")
                }
                HStack {
                    Text("Invested:")
                    Text("$\(gsData.totalCost(array: gsData.items))")
                }
            case .fav:
                HStack {
                    Text("Items:")
                    Text("\(gsData.favItems.count)")
                }
                HStack {
                    Text("Weight:")
                    Text("\(gsData.totalWeight(array: gsData.favItems))g")
                }
                HStack {
                    Text("Invested:")
                    Text("$\(gsData.totalCost(array: gsData.favItems))")
                }
            case .regret:
                HStack {
                    Text("Items:")
                    Text("\(gsData.regretItems.count)")
                }
                HStack {
                    Text("Invested:")
                    Text("$\(gsData.totalCost(array: gsData.regretItems))")
                }
            case .wish:
                HStack {
                    Text("Items:")
                    Text("\(gsData.wishListItems.count)")
                }
                HStack {
                    Text("Cost:")
                    Text("$\(gsData.totalCost(array: gsData.wishListItems))")
                }
            case .adventure:
                HStack {
                    Text("Lists:")
                }
            case .activity:
                HStack {
                    Text("Lists:")
                }
            case .list:
                HStack {
                    Text("Items:")
                    Text("\(gearlist!.items.count)")
                }
                HStack {
                    Text("Weight:")
                    Text("\(glData.gearlistTotalWeight(gearlist: gearlist!))g")
                }
            case .pile:
                Text (
                    "Items: " +
                    "\(glData.gearlistClusterTotalItems(gearlist: gearlist!))"
                )
                Text (
                    "Weight: " +
                    "\(glData.gearlistClusterTotalWeight(gearlist: gearlist!))" +
                    "g"
                )
            case .pack:
                Text (
                    "Packed: " +
                    "\(glData.gearlistContainerBoolTotals(gearlist: gearlist!))" +
                    " of " +
                    "\(glData.gearlistContainerTotalItems(gearlist: gearlist!))"
                )
                
                Text (
                    "Weight: " +
                    "\(glData.gearlistContainerTotalWeight(gearlist: gearlist!))" +
                    "g"
                )
            }
            Spacer()
        }
        .font(.custom("HelveticaNeue", size: 14))
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
    }
}
