//
//  ItemActivityList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//
/*
import SwiftUI

struct ItemActivityList: View {
    
    @ObservedObject var item: Item
    
    @EnvironmentObject private var viewModel: GearlistData
    
    var body: some View {
        VStack (spacing: 0){
            StatBar(statType: .shed)
            activityList
        }
        
    }
    private var activityList: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders){
                ForEach(viewModel.sectionByType(array: item.activities)) { section in
                    Section {
                        sectionContent(section: section)
                    } header: {
                        sectionHeader(section: section)
                    }
                }
            }
        }
    }
    
    private func sectionContent(section: SectionTypeData) -> some View {
        ForEach(section.activites) { activity in
            ActivityRowView(activity: activity)
        }
    }
    
    private func sectionHeader(section: SectionTypeData) -> some View {
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
*/
