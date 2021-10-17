//
//  TripContextMenu.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-16.
//

import Foundation
import SwiftUI

// this is common code for both the shopping list tab and the purchased tab to build a
// context menu associated with an Item

// note for itemContextMenu below: in XCode 11.5/iOS 13.5, you'll get plenty of layout
// messages about unsatisfiable constraints in the console when displaying a contextMenu.
// that's apparently a SwiftUI problem that seems to not be present in XCode 12/iOS 14 so much

/// Builds out a context menu for an Item that can be used in the main gear shed
/// to quickly move the item to the other list, toggle the state
/// of the availability, and delete the item.
/// - Parameter item: the Item to which this menu is attached
/// - Parameter deletionTrigger: a closure to call to set state variables and put up an "Are you sure?" alert before allowing deletion of the item
/// - Returns: Void
@ViewBuilder
func tripContextMenu(trip: Trip, deletionTrigger: @escaping () -> Void) -> some View {
    
    // Delete Trip Option
    Button(action: { deletionTrigger() }) {
        Text("Delete This Trip")
        Image(systemName: "trash")
    }
    
}
