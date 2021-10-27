//
//  ItemRowViewInWishlist.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//

import SwiftUI

struct ItemRowViewInWishList: View {

    @ObservedObject var item: Item
    
    var body: some View {
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            favouriteButton
            NavigationLink(destination: ItemDetailView(item: item)) {
                navLinkBody
            }
        }
        .padding(.horizontal)
    }
    
    private var favouriteButton: some View {
        Image(systemName: item.isFavourite ? "heart.fill" : "heart")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            .opacity(0)
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
                        .frame(maxHeight: 35)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            Spacer()
        }
    }
}
