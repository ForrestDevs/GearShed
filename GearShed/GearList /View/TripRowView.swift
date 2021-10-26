//
//  TripRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct TripRowView: View {
    
    var gearlist: Gearlist

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                NavigationLink(destination: TripDetailView(gearlist: gearlist, gearlistFromParent: gearlist)) {
                    Text(gearlist.name)
                        .font(.headline)
                }
            }
        }
    }
}


