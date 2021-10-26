//
//  ItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation
import SwiftUI

struct ItemRowView: View {

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
                        //.font(.headline)
                        .foregroundColor(Color.theme.accent)
                    
                    Text("|")
                    
                    Text(item.name)
                        //.font(.headline)
                        .foregroundColor(Color.theme.green)
                }
                
                HStack {
                    // quantity at the right
                    Text("\(item.weight) g")
                        .font(.caption)
                        //.font(.system(size: 10))
                        //.bold()
                        .foregroundColor(Color.theme.green)
                        //.padding(.horizontal)
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        
                    //Spacer()
                }
                .frame(maxHeight: 35)
            }
            Spacer()
        }
    }
    
}

struct ItemRowViewInBrand: View {

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
                    // quantity at the right
                    Text("\(item.weight) g")
                        .font(.caption)
                        //.font(.system(size: 10))
                        //.bold()
                        .foregroundColor(Color.theme.green)
                        //.padding(.horizontal)
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        
                    //Spacer()
                }
                .frame(maxHeight: 35)
            }
            Spacer()
        }
    }
    
}

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
                        //.font(.headline)
                        .foregroundColor(Color.theme.accent)
                    
                    Text("|")
                    
                    Text(item.name)
                        //.font(.headline)
                        .foregroundColor(Color.theme.accent)
                }
                HStack {
                    // quantity at the right
                    Text("$\(item.price)")
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                    
                    // quantity at the right
                    Text("\(item.weight)g")
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                .frame(maxHeight: 35)
                
                
            }
            Spacer()
        }
    }
}

struct ItemRowViewInShed: View {

    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            HStack {
                Image(systemName: "square.fill")
                    .resizable()
                    .font(.title)
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.theme.background)
                    .padding(.horizontal,4)
                
                // Name, Brand, Details
                VStack (alignment: .leading) {
                    
                    HStack {
                        Text(item.brandName)
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("|")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text(item.name)
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack {
                    // quantity at the right
                    Text("\(item.weight) g")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.theme.green)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
    
}










