//
//  ItemDiaryList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct ItemDiaryList: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        VStack (spacing: 0) {
            adventureDiaries
            activityDiaries
        }
    }
}

extension ItemDiaryList {
    
    private var adventureDiaries: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders)  {
                ForEach(item.adventures) { adventure in
                    Section {
                        adventureContent(adventure: adventure)
                    } header: {
                        adventureHeader(adventure: adventure)
                    }
                }
            }
        }
    }
    
    private func adventureContent(adventure: Gearlist) -> some View {
        ForEach(adventure.diaries) { diary in
            ItemDiaryRowView(diary: diary)
        }
    }
    
    private func adventureHeader(adventure: Gearlist) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            
            HStack {
                Text(adventure.name).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
    
    private var activityDiaries: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders){
                ForEach(item.activities) { activity in
                    Section {
                        activityContent(activity: activity)
                    } header: {
                        activityHeader(activity: activity)
                    }
                }
            }
        }
    }
    
    private func activityContent(activity: Gearlist) -> some View {
        ForEach(activity.diaries) { diary in
            ItemDiaryRowView(diary: diary)
        }
    }
    
    private func activityHeader(activity: Gearlist) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            
            HStack {
                Text(activity.name).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
    
}
