//
//  GearlistOBCView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-09-27.
//

import SwiftUI

struct GearlistOBCView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject var gearlist: Gearlist
    
    var body: some View {
        VStack(spacing: 0) {
            StatBar(statType: .obc, gearlist: gearlist)
            ScrollView {
                LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        sectionItems(type: .onBody)
                    } header: {
                        sectionHeader(type: .onBody)
                    }
                    Section {
                        sectionItems(type: .baseWeight)
                    } header: {
                        sectionHeader(type: .baseWeight)
                    }
                    Section {
                        sectionItems(type: .consumable)
                    } header: {
                        sectionHeader(type: .consumable)
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
    

    private func sectionItems(type: OBCType) -> some View {
        VStack {
            switch type {
            case .onBody:
                ForEach(gearlist.onbodygear.items) { item in
                    ItemRowViewInOBC(gearlist: gearlist, item: item, type: .onBody)
                }
            case .baseWeight:
                ForEach(gearlist.baseweightgear.items) { item in
                    ItemRowViewInOBC(gearlist: gearlist, item: item, type: .baseWeight)
                }
            case .consumable:
                ForEach(gearlist.consumablegear.items) { item in
                    ItemRowViewInOBC(gearlist: gearlist, item: item, type: .consumable)
                }
            }
        }
    }
    
    
    private func sectionHeader(type: OBCType) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            
            HStack {
                switch type {
                case .onBody:
                    Text("On Body")
                        .font(.headline)
                    if (Prefs.shared.weightUnit == "g") {
                        Text("\(viewModel.totalGrams(array: gearlist.onbodygear.items))g")
                    }
                    if (Prefs.shared.weightUnit == "lb + oz") {
                        let LbOz = viewModel.totalLbsOz(array: gearlist.onbodygear.items)
                        let lbs = LbOz.lbs
                        let oz = LbOz.oz
                        Text("\(lbs) lbs \(oz) oz")
                    }
                case .baseWeight:
                    Text("Base Weight")
                        .font(.headline)
                    if (Prefs.shared.weightUnit == "g") {
                        Text("\(viewModel.totalGrams(array: gearlist.baseweightgear.items))g")
                    }
                    if (Prefs.shared.weightUnit == "lb + oz") {
                        let LbOz = viewModel.totalLbsOz(array: gearlist.baseweightgear.items)
                        let lbs = LbOz.lbs
                        let oz = LbOz.oz
                        Text("\(lbs) lbs \(oz) oz")
                    }
                case .consumable:
                    Text("Consumable")
                        .font(.headline)
                    if (Prefs.shared.weightUnit == "g") {
                        Text("\(viewModel.totalGrams(array: gearlist.consumablegear.items))g")
                    }
                    if (Prefs.shared.weightUnit == "lb + oz") {
                        let LbOz = viewModel.totalLbsOz(array: gearlist.consumablegear.items)
                        let lbs = LbOz.lbs
                        let oz = LbOz.oz
                        Text("\(lbs) lbs \(oz) oz")
                    }
                }
                Spacer()
                Menu {
                    Button {
                        detailManager.selectedGearlist = gearlist
                        switch type {
                        case .onBody:
                            withAnimation {
                                detailManager.secondaryTarget = .showAddItemsToOnBodyGear
                            }
                        case .baseWeight:
                            withAnimation {
                                detailManager.secondaryTarget = .showAddItemsToBaseWeightGear
                            }
                        case .consumable:
                            withAnimation {
                                detailManager.secondaryTarget = .showAddItemsToConsumableGear
                            }
                        }
                    } label: {
                        HStack {
                            switch type {
                            case .onBody:
                                Text("Edit On Body Gear").textCase(.none)
                            case .baseWeight:
                                Text("Edit Base Weight Gear").textCase(.none)
                            case .consumable:
                                Text("Edit Consumable Gear").textCase(.none)
                            }
                            Image(systemName: "plus")
                        }
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

//struct GearlistOBCView_Previews: PreviewProvider {
//    static var previews: some View {
//        GearlistOBCView()
//    }
//}
