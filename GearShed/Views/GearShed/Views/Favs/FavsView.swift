//
//  FavsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct FavsView: View {
    
    @EnvironmentObject private var gsData: GearShedData

    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .fav)
            if gsData.favItems.count == 0 {
                EmptyViewTextNonButton(emptyText: "favourite Items", buttonName: "favourite")
            } else {
                List {
                    ForEach(gsData.sectionByShed(itemArray: gsData.favItems)) { section in
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
