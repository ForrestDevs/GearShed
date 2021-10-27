//
//  ViewBuildingCode.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
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
func listItemContextMenu(item: Item, deletionTrigger: @escaping () -> Void) -> some View {
	Button(action: { deletionTrigger() }) {
		Text("Remove Item From List")
		Image(systemName: "trash")
	}
}

@ViewBuilder
func listRowContextMenu(editTrigger: @escaping () -> Void, deletionTrigger: @escaping () -> Void) -> some View {
    
    Button(action: { editTrigger() }) {
        Text("Rename List")
        Image(systemName: "square.and.pencil")
    }
    
    Button(action: { deletionTrigger() }) {
        Text("Delete List")
        Image(systemName: "trash")
    }
}

@ViewBuilder
func shedRowContextMenu(editTrigger: @escaping () -> Void, deletionTrigger: @escaping () -> Void) -> some View {
    
    Button(action: { editTrigger() }) {
        Text("Rename Shed")
        Image(systemName: "square.and.pencil")
    }
    
    Button(action: { deletionTrigger() }) {
        Text("Delete Shed")
        Image(systemName: "trash")
    }
}

@ViewBuilder
func brandRowContextMenu(editTrigger: @escaping () -> Void, deletionTrigger: @escaping () -> Void) -> some View {
    
    Button(action: { editTrigger() }) {
        Text("Rename Brand")
        Image(systemName: "square.and.pencil")
    }
    
    Button(action: { deletionTrigger() }) {
        Text("Delete Brand")
        Image(systemName: "trash")
    }
}






// Old
/*@ViewBuilder
func itemContextMenu(item: Item, deletionTrigger: @escaping () -> Void) -> some View {
    
    Button(action: { item.toggleWishlistStatus() }) {
        Text(item.wishlist ? "Move to Purchased" : "Move to ShoppingList")
        Image(systemName: item.wishlist ? "purchased" : "cart")
    }
    
    Button(action: { item.toggleFavouriteStatus() }) {
        Text(item.isFavourite ? "Mark as Favorite" : "Mark as Favorite")
        Image(systemName: item.isFavourite ? "pencil.slash" : "pencil")
    }
    
    Button(action: { deletionTrigger() }) {
        Text("Remove Item From List")
        Image(systemName: "trash")
    }
}*/