//
//  ShedRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ShedRowView: View {
        
    @ObservedObject var shed: Shed

    var body: some View {
        NavigationLink(destination: ShedDetailView(shed: shed)) {
            HStack {
                Text(shed.name)
                    .font(.headline)
                Spacer()
                Text("\(shed.items.count)")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 20)
    }
}



