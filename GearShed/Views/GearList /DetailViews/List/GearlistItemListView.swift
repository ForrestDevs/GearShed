//
//  GearlistItemListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct GearlistItemListView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject var gearlist: Gearlist
        
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .list, gearlist: gearlist)
            ZStack {
                if gearlist.items.count == 0 {
                    EmptyViewText(text: "You have not added any gear to this list. To add gear press the 'Select Gear' button below.")
                } else {
                    itemList
                }
                addItemButtonOverlay
            }
        }
    }
    //MARK: Main Content
    private var itemList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.sectionByShed(itemArray: gearlist.items)) { section in
                    Section {
                        sectionItems(section: section)
                    } header: {
                        sectionHeader(section: section)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    private var addItemButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.secondaryTarget = .noView
                    //detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddItemsToGearlist
                    }
                }
                label: {
                    VStack{
                        Text("Select")
                        Text("Gear")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    private func sectionItems(section: SectionShedData) -> some View {
        ForEach(section.items) { item in
            ItemRowViewInGearlist(persistentStore: persistentStore, item: item, gearlist: gearlist)
        }
    }
    private func sectionHeader(section: SectionShedData) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(section.title)
                    .font(.headline)
                Spacer()
                if (Prefs.shared.weightUnit == "g") {
                    Text("\(viewModel.totalGrams(array: section.items))" + "g" )
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    let LbOz = viewModel.totalLbsOz(array: section.items)
                    let lbs = LbOz.lbs
                    let oz = LbOz.oz
                    Text("\(lbs) lbs \(oz) oz")
                }
            }
            .padding(.horizontal, 15)
        }
    }
}
