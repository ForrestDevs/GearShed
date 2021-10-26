//
//  TripVM.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import Foundation

final class TripVM: ObservableObject {
    
    let manager = PersistentStore.shared.context
    
    // state variable to control triggering confirmation of a delete, which is
    // one of three context menu actions that can be applied to an item
    @Published var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    
    func deleteGearlist(gearlist: Gearlist) {
        let gearlist = gearlist
        manager.delete(gearlist)
    }
    
}
