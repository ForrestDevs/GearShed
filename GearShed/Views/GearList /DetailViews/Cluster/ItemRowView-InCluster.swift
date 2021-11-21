//
//  ItemRowView-InCluster.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ItemRowView_InCluster: View {
    
    @EnvironmentObject private var viewModel: GearlistData
    
    private var gearlist: Gearlist?
    private var cluster: Cluster?
    
    @ObservedObject var item: Item
    
    var body: some View {
        ZStack {
            Color.clear
            itemBody
        }
        .contextMenu {
            if cluster == nil {
                moveToCluster
            } else {
                deleteContextButton
            }
        }
    }

}

extension ItemRowView_InCluster {
    
    init(gearlist: Gearlist, item: Item) {
        self.gearlist = gearlist
        self.item = item
    }
    
    init(cluster: Cluster, item: Item) {
        self.cluster = cluster
        self.item = item
    }
    
    private var itemBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                HStack {
                    HStack (spacing: 5) {
                        Text(item.name)
                            .formatItemNameGreen()
                            .fixedSize()
                        statusIcon
                    }
                    Text("|")
                        .formatItemNameBlack()
                    Text(item.brandName)
                        .formatItemNameBlack()
                }
                .lineLimit(1)
                
                HStack {
                    Text(item.weight + "g")
                        .formatItemWeightBlack()
                    Text(item.detail)
                        .formatItemDetailsGrey()
                }
                .lineLimit(1)
            }
            Spacer()
        }
        
        /*HStack {
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(item.name)
                        .foregroundColor(Color.theme.green)
                    Text("|")
                    Text(item.brandName)
                        .foregroundColor(Color.theme.accent)
                }
                HStack {
                    
                    .font(.caption)
                    .foregroundColor(Color.theme.accent)
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxHeight: 35)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 5)*/
    }

    private var statusIcon: some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            } else
            if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            } else
            if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            }
        }
    }
    
    private var moveToCluster: some View {
        ForEach(gearlist!.clusters) { cluster in
            Button {
                viewModel.updateItemCluster(newCluster: cluster, oldCluster: nil, item: item)
            } label: {
                Text(cluster.name)
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            withAnimation {
                viewModel.removeItemFromCluster(item: item, cluster: cluster!)
            }
        } label: {
            HStack {
                Text("Remove From Pile")
                Image(systemName: "trash")
            }
        }
    }
    
}
