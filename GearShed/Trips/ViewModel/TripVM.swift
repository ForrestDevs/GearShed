//
//  TripVM.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-16.
//

import Foundation

final class TripVM: ObservableObject {
    
    let manager = PersistentStore.shared.context
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteTripAlert: ConfirmDeleteTripAlert?
    
    func deleteTrip(trip: Trip) {
        let trip = trip
        manager.delete(trip)
    }
    
}
