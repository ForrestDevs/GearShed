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
    
    @StateObject private var viewModel = TripVM()

    var body: some View {
        
        // List of Trips
        Form {
            Section(header: Text("Trips Listed: \(allFetchedTrips.count)").sectionHeader()) {
                ForEach(allFetchedTrips) { trip in
                    TripRowView(trip: trip)
                        .contextMenu { tripContextMenu(trip: trip, deletionTrigger: { viewModel.confirmDeleteTripAlert = ConfirmDeleteTripAlert(trip: trip) }) }
                }
            }
            .alert(item: $viewModel.confirmDeleteTripAlert) { trip in trip.alert() }
        }
        
    }
}

