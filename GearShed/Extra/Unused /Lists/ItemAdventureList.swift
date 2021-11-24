//
//  ItemAdventureList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//
/*
import SwiftUI

struct ItemAdventureList: View {
    
    @ObservedObject var item: Item
    
    @EnvironmentObject private var viewModel: GearlistData
    
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .shed)
            adventureList
        }
    }
}

extension ItemAdventureList {
    
    private var adventureList: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.sectionByYear(array: item.adventures)) { section in
                    Section {
                        sectionContent(section: section)
                    } header: {
                        sectionHeader(section: section)
                    }
                }
            }
        }
    }
    
    private func sectionContent(section: SectionYearData) -> some View {
        ForEach(section.adventures) { adventure in
            AdventureRowView(adventure: adventure)
        }
    }
    
    private func sectionHeader(section: SectionYearData) -> some View {
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



/*ScrollView {
    LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
        ForEach(1..<15) { x in
            Section {
                ForEach(1..<10) { i in
                    HStack {
                        Text("\(i)")
                        Spacer()
                    }
                }
            } header: {
                ZStack {
                    Color.theme.headerBG
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                    HStack {
                        Text("Header \(x)")
                        Spacer()
                    }
                }
            }
        }
    }
}*/
*/
