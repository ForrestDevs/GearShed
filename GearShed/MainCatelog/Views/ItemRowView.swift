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
                        Text(item.name)
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        
                        Text("|")
                        
                        Text(item.brandName)
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
                    Text("100$")
                        .font(.caption)
                }
            }
            .padding(.horizontal)
        }
	}
    
}







