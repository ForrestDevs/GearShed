//
//  TripRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistRowView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var gearlist: Gearlist

    var body: some View {
        NavigationLink(destination: GearlistDetailView(persistentStore: persistentStore, gearlist: gearlist)) {
            HStack {
                Text(gearlist.name)
                    .font(.headline)
                Spacer()
                Text("\(gearlist.items.count)")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 20)
    }
}


