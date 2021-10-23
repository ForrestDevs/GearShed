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

    // we treat the item as an @ObservedObject: we want to get redrawn if any property changes.
	@ObservedObject var item: Item
    
    @State var isFavourited: Bool = false
	
	var body: some View {
        
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            
            Image(systemName: item.isFavourite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 13, height: 12)
                .foregroundColor(Color.theme.green)
                .padding(.vertical, -1)
                .onTapGesture {
                    isFavourited.toggle()
                    item.toggleFavouriteStatus()
                }
            
            NavigationLink(destination: ItemDetailView(item: item)) {
                HStack {
                    // Name, Brand, Details
                    VStack (alignment: .leading) {
                        
                        HStack {
                            Text(item.brandName)
                                //.font(.headline)
                                .foregroundColor(Color.theme.accent)
                            
                            Text("|")
                            
                            Text(item.name)
                                //.font(.headline)
                                .foregroundColor(Color.theme.accent)
                            
                            Text("|")
                                .foregroundColor(Color.theme.accent)
                            
                            // quantity at the right
                            Text("\(item.weight) g")
                                .font(.system(size: 15))
                                //.bold()
                                .foregroundColor(Color.theme.green)
                                //.padding(.horizontal)
                        }
                        
                        Text(item.detail)
                            .font(.caption)
                            .foregroundColor(Color.theme.secondaryText)
                        
                        
                    }
                    
                    Spacer()
                    
                    
                }
            }
            
        }
        .padding(.horizontal)
    }
}







