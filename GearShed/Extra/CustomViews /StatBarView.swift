//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

enum StatType {
    case shed, brand, fav, regret, wish, adventure, activity, list, pile, pack, diary, obc
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
            case .obc:
                obcStats
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
                Text("Weight")
                    .formatStatBarTitle()
                Text(gsData.weightForStatBar(array: gsData.items))
                    .formatStatBarContent()
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
                Text("Weight")
                    .formatStatBarTitle()
                Text(gsData.weightForStatBar(array: gsData.favItems))
                    .formatStatBarContent()
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
                Text("Weight")
                    .formatStatBarTitle()
                Text("\(glData.weightForGearlistStat(gearlist: gearlist!, type: "list"))")
                    .formatStatBarContent()
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
                Text("Weight")
                    .formatStatBarTitle()
                Text(glData.weightForGearlistStat(gearlist: gearlist!, type: "pile"))
                    .formatStatBarContent()
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
                Text("Weight")
                    .formatStatBarTitle()
                Text(glData.weightForGearlistStat(gearlist: gearlist!, type: "pack"))
                    .formatStatBarContent()
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
    private var obcStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Items")
                    .formatStatBarTitle()
                Text("\(glData.gearlistOBCTotalItems(gearlist: gearlist!))")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight")
                    .formatStatBarTitle()
                Text(glData.weightForGearlistStat(gearlist: gearlist!, type: "obc"))
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
}
