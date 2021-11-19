//
//  RegretsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import SwiftUI

struct RegretsView: View {
        
    @EnvironmentObject private var gsData: GearShedData

    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .regret)
            if gsData.regretItems.count == 0 {
                EmptyViewTextNonButton(emptyText: "regret Items", buttonName: "regret")
            } else {
                List {
                    ForEach(gsData.sectionByShed(itemArray: gsData.regretItems)) { section in
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
                .listStyle(.plain)
            }
            
        }
        
    }
}
