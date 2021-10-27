//
//  ItemRowViewInShed.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//

import SwiftUI

struct ItemRowViewInShed: View {

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
            .onTapGesture {
                item.toggleRegretStatus()
                item.toggleFavouriteStatus()
            }
    }
    
    private var navLinkBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 0) {
                Text(item.name)
                    .foregroundColor(Color.theme.accent)
                HStack {
                    Text("\(item.weight)g")
                    Text(item.detail)
                        .frame(maxHeight: 35)
                }
                .font(.caption)
                .foregroundColor(Color.theme.green)
            }
            Spacer()
        }
    }
    
}
