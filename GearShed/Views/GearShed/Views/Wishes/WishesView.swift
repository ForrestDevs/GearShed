//
//  WishesView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct WishesView: View {
    
    @EnvironmentObject private var gsData: GearShedData

    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .wish)
            if gsData.wishListItems.count == 0 {
                EmptyViewTextNonButton(emptyText: "Wishes", buttonName: "wish")
            } else {
                listView
                /*List {
                    ForEach(gsData.sectionByShed(itemArray: gsData.wishListItems)) { section in
                        Section {
                            ForEach(section.items) { item in
                                ItemRowView(item: item)
                            }
                        } header: {
                            HStack {
                                Text(section.title).textCase(.none)
                                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                                Spacer()
                            }
                            
                        }
                    }
                }
                .listStyle(.plain)*/
            }
            
        }
        
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach (gsData.sectionByShed(itemArray: gsData.wishListItems)) { section in
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
        ForEach (section.items) { item in
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

