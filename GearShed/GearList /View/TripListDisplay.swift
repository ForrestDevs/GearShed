//
//  TripListDisplay.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct TripListDisplay: View {
    
    // this is the @FetchRequest that ties this view to Core Data Trips
    @FetchRequest(fetchRequest: Gearlist.allGearlistsFR())
    private var allGearlists: FetchedResults<Gearlist>
    
    @StateObject private var viewModel = TripVM()

    var body: some View {
        
        // List of Trips
        Form {
            Section(header: Text("Gearlists Listed: \(allGearlists.count)").sectionHeader()) {
                ForEach(allGearlists) { gearlist in
                    TripRowView(gearlist: gearlist)
                        .contextMenu { gearlistContextMenu(gearlist: gearlist, deletionTrigger: { viewModel.confirmDeleteGearlistAlert = ConfirmDeleteGearlistAlert(gearlist: gearlist) }) }
                }
            }
            .alert(item: $viewModel.confirmDeleteGearlistAlert) { gearlist in gearlist.alert() }
        }
        
    }
}

