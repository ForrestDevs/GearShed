//
//  ItemRowView-InCluster.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ItemRowView_InCluster: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(item.brandName)
                    .foregroundColor(Color.theme.accent)
                Text("|")
                Text(item.name)
                    .foregroundColor(Color.theme.green)
            }
            HStack {
                Text(item.weight + "g")
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxHeight: 35)
            }
        }
    }
}
