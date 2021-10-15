//
//  TripListDisplay.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-07.
//

import SwiftUI

struct TripListDisplay: View {
    
    // this is the @FetchRequest that ties this view to Core Data Trips
    @FetchRequest(fetchRequest: Trip.allTripsFR())
    private var allFetchedTrips: FetchedResults<Trip>

    var body: some View {
        
        // List of Trips
        Form {
            Section(header: Text("Trips Listed: \(allFetchedTrips.count)").sectionHeader()) {
                ForEach(allFetchedTrips) { trip in
                    TripRowView(trip: trip)
                        .contextMenu { contextMenuButton(for: trip) }
                } // end of ForEach
            } // end of Section
        }
    }
    
    // a convenient way to build this context menu without having it in-line
    // in the view code above
    @ViewBuilder
    func contextMenuButton(for trip: Trip) -> some View {
        Button(action: {
        }) {
            Text("Delete This Trip")
            Image(systemName: "trash")
        }
    }
    
}

