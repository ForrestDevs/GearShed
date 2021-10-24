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
    
    @StateObject private var viewModel = MainCatelogVM()

    // we treat the item as an @ObservedObject: we want to get redrawn if any property changes.
	@ObservedObject var item: Item
    
	var body: some View {
        
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            
            Image(systemName: item.isFavourite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 13, height: 12)
                .foregroundColor(Color.theme.green)
                .padding(.vertical, -1)
                .onTapGesture {
                    viewModel.isFavourited.toggle()
                    item.toggleFavouriteStatus()
                }
            
            NavigationLink(destination: ItemDetailView(item: item)) {
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
        .padding(.horizontal)
    }
}

struct ItemRowViewInWishList: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    // we treat the item as an @ObservedObject: we want to get redrawn if any property changes.
    @ObservedObject var item: Item
    
    var body: some View {
        
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            
            Image(systemName: item.isFavourite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 13, height: 12)
                .foregroundColor(Color.theme.green)
                .padding(.vertical, -1)
                .opacity(0)
            
            NavigationLink(destination: ItemDetailView(item: item)) {
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
                            Text("$100,000")
                                .font(.caption)
                                //.font(.system(size: 10))
                                //.bold()
                                .foregroundColor(Color.theme.green)
                                //.padding(.horizontal)
                            
                            // quantity at the right
                            Text("\(item.weight)g")
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
        .padding(.horizontal)
    }
}







