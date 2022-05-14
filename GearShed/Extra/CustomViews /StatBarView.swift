//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

enum StatType {
    case shed, brand, fav, regret, wish, adventure, activity, list, pile, pack, diary
}

struct StatBar: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var gsData: GearShedData
    @EnvironmentObject private var glData: GearlistData
    @State var statType: StatType
    @State var gearlist: Gearlist?
    
    var body: some View {
        VStack (spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.theme.green)
                .padding(.bottom, 2)
            switch statType {
            case .shed:
                shedStats
                    .padding(.leading)
            case .brand:
                brandStats
                    .padding(.leading)
            case .fav:
                favStats
                    .padding(.leading)
            case .regret:
                regretStats
                    .padding(.leading)
            case .wish:
                wishStats
                    .padding(.leading)
            case .adventure:
                adventureStats
                    .padding(.leading)
            case .activity:
                actvivtyStats
                    .padding(.leading)
            case .list:
                listStats
                    .padding(.leading)
            case .pile:
                pileStats
                    .padding(.leading)
            case .pack:
                packStats
                    .padding(.leading)
            case .diary:
                diaryStats
                    .padding(.leading)
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.theme.green)
                .padding(.top, 4)
        }
        .padding(.top, 2)
        .padding(.bottom, 5)
    }
    //MARK: Main Content
    private var shedStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Shelves")
                    .formatStatBarTitle()
                Text("\(gsData.sheds.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(gsData.items.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                // Stat for total weight in Grams
                if (Prefs.shared.weightUnit == "g") {
                    Text("Weight")
                        .formatStatBarTitle()
                    Text("\(gsData.totalGrams(array: gsData.items)) g")
                        .formatStatBarContent()
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    Text("Weight")
                        .formatStatBarTitle()
                    let totalLbsOz = gsData.totalLbsOz(array: gsData.items)
                    let totalLbs = totalLbsOz.lbs
                    let totalOz = totalLbsOz.oz
                    Text("\(totalLbs) lb \(totalOz) oz")
                        .formatStatBarTitle()
                }
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.items))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var brandStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Brands")
                    .formatStatBarTitle()
                Text("\(gsData.brands.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var favStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(gsData.favItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                // Stat for total weight in Grams
                if (Prefs.shared.weightUnit == "g") {
                    Text("Weight")
                        .formatStatBarTitle()
                    
                    Text("\(gsData.totalGrams(array: gsData.favItems)) g")
                        .formatStatBarContent()
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    Text("Weight")
                        .formatStatBarTitle()
                    let totalLbsOz = gsData.totalLbsOz(array: gsData.favItems)
                    let totalLbs = totalLbsOz.lbs
                    let totalOz = totalLbsOz.oz
                    Text("\(totalLbs) lbs \(totalOz) oz")
                        .formatStatBarTitle()
                }
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.favItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var regretStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(gsData.regretItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.regretItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var wishStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(gsData.wishListItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Cost")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.wishListItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var adventureStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Adventures")
                    .formatStatBarTitle()
                Text("\(glData.adventures.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Bucketlists")
                    .formatStatBarTitle()
                Text("\(glData.bucklists.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var actvivtyStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Activities")
                    .formatStatBarTitle()
                Text("\(glData.activities.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Types")
                    .formatStatBarTitle()
                Text("\(glData.activityTypes.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    private var listStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(gearlist!.items.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                // Stat for total weight in Grams
                if (Prefs.shared.weightUnit == "g") {
                    Text("Weight")
                        .formatStatBarTitle()
                    Text("\(glData.gearlistTotalGrams(gearlist: gearlist!)) g")
                        .formatStatBarContent()
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    Text("Weight")
                        .formatStatBarTitle()
                    let totalLbsOz = glData.gearlistTotalLbsOz(gearlist: gearlist!)
                    let totalLbs = totalLbsOz.lbs
                    let totalOz = totalLbsOz.oz
                    Text("\(totalLbs) lbs \(totalOz) oz")
                        .formatStatBarTitle()
                }
            }
            Spacer()
        }
    }
    private var pileStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(glData.gearlistPileTotalItems(gearlist: gearlist!))")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                if (Prefs.shared.weightUnit == "g") {
                    Text("Weight")
                        .formatStatBarTitle()
                    Text("\(glData.gearlistPileTotalGrams(gearlist: gearlist!)) g" )
                        .formatStatBarContent()
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    Text("Weight")
                        .formatStatBarTitle()
                    let totalLbsOz = glData.gearlistPileTotalLbsOz(gearlist: gearlist!)
                    let totalLbs = totalLbsOz.lbs
                    let totalOz = totalLbsOz.oz
                    Text("\(totalLbs) lbs \(totalOz) oz")
                        .formatStatBarTitle()
                }
            }
            Spacer()
        }
    }
    private var packStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear Packed")
                    .formatStatBarTitle()
                Text(
                    "\(glData.gearlistPackingBoolTotals(gearlist: gearlist!))" +
                     " of " +
                     "\(glData.gearlistPackTotalItems(gearlist: gearlist!))"
                )
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                if (Prefs.shared.weightUnit == "g") {
                    Text("Weight")
                        .formatStatBarTitle()
                    Text("\(glData.gearlistPackTotalGrams(gearlist: gearlist!)) g")
                        .formatStatBarContent()
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    Text("Weight")
                        .formatStatBarTitle()
                    let totalLbsOz = glData.gearlistPackTotalLbsOz(gearlist: gearlist!)
                    let totalLbs = totalLbsOz.lbs
                    let totalOz = totalLbsOz.oz
                    Text("\(totalLbs) lbs \(totalOz) oz")
                        .formatStatBarTitle()
                }
            }
            Spacer()
        }
    }
    private var diaryStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Entries")
                    .formatStatBarTitle()
                Text("\(gearlist!.diaries.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
}
