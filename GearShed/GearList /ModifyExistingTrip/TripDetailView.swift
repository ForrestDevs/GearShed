//
//  TripDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct TripDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // this is a temporary holding array for items being added to a trip.  it's a
    // @State variable, so if any SelectableItemRowView or a context menu adds an Item
    // to this array, we will get some redrawing + animation;
    @State private var itemsChecked = [Item]()
    
    // local state to trigger showing a sheet to add a new item to trip
    @State private var isAddNewItemToTripSheetShowing = false

    var multiSectionDisplay = true
    
    // parameter to control triggering an Alert and defining what action
    // to take upon confirmation
    @State private var confirmDeleteTripAlert: ConfirmDeleteTripAlert?
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableGearlistData: EditableGearlistData
    
    var gearlistFromParent: Gearlist
    
    var gearlist: Gearlist
    
    // custom init to set up editable data
    init(gearlist: Gearlist, gearlistFromParent: Gearlist) {
        _editableGearlistData = State(initialValue: EditableGearlistData(gearlist: gearlist))
        self.gearlist = gearlist
        self.gearlistFromParent = gearlistFromParent
    }
    
    
    var body: some View {
        
        VStack {
        
           SimpleItemsListForTrip(gearlist: gearlistFromParent)
            
        }
        .navigationTitle(editableGearlistData.gearlistName)
        .sheet(isPresented: $isAddNewItemToTripSheetShowing) {
            NavigationView {
                AddItemToTripSheet(gearlist: gearlist)
                    .environment(\.managedObjectContext, PersistentStore.shared.context)
            }
        }
        .toolbar{ ToolbarItem(placement: .navigationBarTrailing, content: trailingButtons) }
        
    }
    
    
    func trailingButtons() -> some View {
        Button(action: { isAddNewItemToTripSheetShowing = true }) {
             Image(systemName: "plus")
            .font(.title2)
        }
    }
    
    // the purpose of this function is to break out the itemsToBePurchased by section,
    // according to whether the list is displayed as a single section or in multiple
    // sections (one for each Shed that contains shopping items on the list)
    
    // The purpose of this function is to add the selected item to our temporary array itemsChecked
    func handleItemSelected(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
    }
    
    // The purpose of this function is to remove the selected item
    // from our temporary array itemsChecked, if the user unselects an item
    func handleItemUnSelected(_ item: Item) {
        self.itemsChecked.removeAll{$0.id == item.id}
    }
    
    func deleteAndDismiss(_ trip: Trip) {
        Trip.delete(trip)
        presentationMode.wrappedValue.dismiss()
    }
    
}


struct SimpleItemsListForTrip: View {
    
    var gearlist: Gearlist
    
    var body: some View {
        VStack (alignment: .leading){
            if let items = gearlist.items_?.allObjects as? [Item] {
                ForEach(items) { item in
                    ItemRowInTrip(item: item)
                }
            }
        }
        
    }
}

struct ItemRowInTrip: View {
    
    @State private var selected: Bool = false
    
    var item: Item
    
    var body: some View {
        HStack {
            ZStack {
                if selected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
            .animation(Animation.easeInOut(duration: 0.5))
            .frame(width: 24, height: 24)
            .onTapGesture {
                selected.toggle()
            }
            
            Text(item.name_ ?? "")
        }
    }
}


