//
//  ItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    
	@ObservedObject var item: Item
    
	var body: some View {
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            favouriteButton
            NavigationLink(destination: ItemDetailView(item: item) ) {
                navLinkBody
            }
        }
    }
    
    private var favouriteButton: some View {
        Image(systemName: item.isFavourite ? "heart.fill" : "heart")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            .onTapGesture {
                if item.isFavourite {
                    item.unmarkFavourite()
                } else {
                    item.markFavourite()
                    item.unmarkRegret()
                }
            }
    }
    
    private var navLinkBody: some View {
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
                    HStack {
                        Text("\(item.weight)g")
                        Text("$\(item.price)")
                    }
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
    
}














