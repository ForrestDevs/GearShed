//
//  ItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 11/28/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import SwiftUI

struct ItemRowView: View {

    // we treat the item as an @ObservedObject: we want to get redrawn if any property changes.
	@ObservedObject var item: Item
	
	var body: some View {
        NavigationLink(destination: AddOrModifyItemView(editableItem: item)) {
            HStack {
                Image(systemName: "square.fill")
                    .resizable()
                    .font(.title)
                    .frame(width: 35, height: 35)
                    .foregroundColor(.blue)
                    .padding(.horizontal,4)
                // Name and Brand
                VStack (alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(Color.theme.accent)
                    
                    Text(item.detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // quantity at the right
                Text("\(item.weight)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color(.blue))
                    .padding(.horizontal)
                
            }
            .padding(.horizontal)
        }
	}
}





