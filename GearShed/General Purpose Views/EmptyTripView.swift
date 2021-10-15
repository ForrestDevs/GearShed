//
//  EmptyTripView.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-10-06.
//  Copyright © 2021 Jerry. All rights reserved.
//

import SwiftUI

// this consolidates the code for what to show when a list is empty
struct EmptyTripView: View {
    var body: some View {
        VStack {
            Group {
                Text("You have")
                    .padding([.top], 200)
                Text("no trips.")
            }
            .font(.title)
            .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct EmptyTripView_Previews: PreviewProvider {
    static var previews: some View {
            EmptyTripView()
    }
}
