//
//  TripRowView.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-10-04.
//  Copyright © 2021 Jerry. All rights reserved.
//

import SwiftUI

// MARK: - TripRowView

struct TripRowView: View {
    
    //@ObservedObject var trip: Trip
    var trip: Trip

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                NavigationLink(destination: TripDetailView(trip: trip, tripFromParent: trip)) {
                    Text(trip.name)
                        .font(.headline)
                }
                /*Text(subtitle())
                    .font(.caption)*/
            }
        } // end of HStack
    } // end of body: some View
        
}


