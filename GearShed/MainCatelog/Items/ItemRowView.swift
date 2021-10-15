//
//  SelectableItemRowView.swift
//  GearShed
//
//  Created by Jerry on 11/28/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - SelectableItemRowView

struct ItemRowView: View {

// we treat the item as an @ObservedObject: we want to get redrawn if any property changes.
	
	@ObservedObject var item: Item
	
	var body: some View {
		HStack {
			
			// Color Bar
			Color(item.uiColor)
				.frame(width: 10, height: 36)
			
			// Name and Brand
			VStack(alignment: .leading) {
				
				
                Text(item.name)
				
				
				Text(item.brandName)
					.font(.caption)
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			// quantity at the right
			Text("\(item.weight)")
				.font(.headline)
				.foregroundColor(Color.blue)
			
		} // end of HStack
	}
}


