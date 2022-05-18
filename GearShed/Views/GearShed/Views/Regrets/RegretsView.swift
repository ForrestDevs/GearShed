//
//  RegretsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct RegretsView: View {
    @EnvironmentObject private var gsData: GearShedData
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .regret)
            if gsData.regretItems.count == 0 {
                EmptyViewText(text: "You currently have no regrets. To access \"Add Gear to Regrets\" feature, press and hold the desired gear item in \"Shelf View\".")
            } else {
                listView
            }
        }
    }
    private var listView: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach (gsData.sectionByShed(itemArray: gsData.regretItems)) { section in
                    Section {
                        sectionContent(section: section)
                    } header: {
                        sectionHeader(section: section)
                    }
                }
            }
            .padding(.bottom, 150)
        }
    }
    private func sectionContent(section: SectionShedData) -> some View {
        ForEach (section.items, id: \.id) { item in
            ItemRowView(item: item)
                .padding(.leading, 15)
        }
    }
    private func sectionHeader(section: SectionShedData) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(section.title).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
}
