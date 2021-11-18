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
        VStack {
            if gsData.wishListItems.count == 0 {
                EmptyViewTextNonButton(emptyText: "Wishes", buttonName: "wish")
            } else {
                List {
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
                .listStyle(.insetGrouped)
            }
            
        }
        
    }
    
}

