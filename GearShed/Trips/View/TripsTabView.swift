//
//  TripsTabView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-07.
//

import SwiftUI

struct TripsTabView: View {
    
    @StateObject private var viewModel = TripVM()
    static let tag: String? = "Trips"
    
    // this is the @FetchRequest that ties this view to CoreData Trips
    @FetchRequest(fetchRequest: Trip.allTripsFR())
    private var allFetchedTrips: FetchedResults<Trip>
    
    // local state to trigger a sheet to appear to add a new trip
    @State private var isAddNewTripSheetShowing = false
    
    // parameters to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteTripAlert: ConfirmDeleteTripAlert?

    // this implements a seemingly well-known strategy to get the list drawn
    // cleanly without any highlighting
    @State private var listDisplayID = UUID()

    var body: some View {
        VStack(spacing: 0) {
            // Page Break Visual Spacer
            Rectangle()
                .frame(height: 1)

            if allFetchedTrips.count == 0 {
                EmptyTripView()
            } else {
                TripListDisplay()
            }
        }
        .navigationBarTitle("Trips", displayMode: .inline)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing, content: addNewTripButton) }
        .sheet(isPresented: $isAddNewTripSheetShowing) {
            NavigationView {
                AddTripView()
                    .environment(\.managedObjectContext, PersistentStore.shared.context) }
            
        }
        .alert(item: $confirmDeleteTripAlert) { item in item.alert() }
        .onAppear {
            logAppear(title: "TripsTabView")
            handleOnAppear()
        }
        .onDisappear() {
            logDisappear(title: "TripsTabView")
            PersistentStore.shared.saveContext()
        }

    } // end of var body: some View

    func handleOnAppear() {
        // updating listDisplayID makes SwiftUI think the list of trips is a whole new
        // list, thereby removing any highlighting.
        listDisplayID = UUID()
    }
    
    // defines the usual "+" button to add a Trip
    private func addNewTripButton() -> some View {
        Button(action: { isAddNewTripSheetShowing = true }) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(Color.theme.green)
        }
    }
}



