//
//  ItemRowView-InCluster.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ItemRowView_InCluster: View {
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var cluster: Cluster
    
    @ObservedObject var item: Item
    
    var body: some View {
        ZStack {
            Color.clear
            HStack {
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
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                        
                        Text(item.detail)
                            .font(.caption)
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(maxHeight: 35)
                    }
                }
                Spacer()
            }
            
        }
        .contextMenu {
            Button {
                withAnimation {
                    viewModel.removeItemFromCluster(item: item, cluster: cluster)
                }
            } label: {
                HStack {
                    Text("Remove Item From Cluster")
                    Image(systemName: "trash")
                }
            }
        }
    }

}
