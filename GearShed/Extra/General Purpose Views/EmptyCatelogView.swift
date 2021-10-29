//
//  EmptyListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// this consolidates the code for what to show when a list is empty
struct EmptyCatelogView: View {
	var body: some View {
		VStack {
			/*Group {
				Text("There are no items")
					.padding([.top], 200)
				Text("in your Main Catelog")
			}
			.font(.title)
			.foregroundColor(.secondary)
			Spacer()*/
		}
	}
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
			EmptyCatelogView()
    }
}
