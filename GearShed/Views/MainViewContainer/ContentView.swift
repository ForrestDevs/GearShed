//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @StateObject private var detailManager: DetailViewManager
    
    init() {
        let detailManager = DetailViewManager()
        _detailManager = StateObject(wrappedValue: detailManager)
    }
    
    var body: some View {
        AppTabBarView()
            .environmentObject(detailManager)
            .ignoresSafeArea(.all, edges: .bottom)
        
            .overlay(detailManager.showAddItem ?
                     (AddItemView(persistentStore: persistentStore, standard: true)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showAddItemFromShed ?
                     (AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showAddItemFromBrand ?
                     (AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showItemDetail ?
                     (ItemDetailView(item: detailManager.selectedItem!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showAddShed ?
                     (AddShedView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showModifyItem ?
                     (ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showModifyShed ?
                     (ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showAddBrand ?
                     (AddBrandView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showModifyBrand ?
                     (ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            // MARK: Gearlist
        
            .overlay(detailManager.showAddGearlist ?
                     (AddGearlistView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            
        
            .overlay(detailManager.showGearlistDetail ?
                     (GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showAddItemsToGearlist ?
                     (AddItemsToGearListView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showModifyGearlist ?
                     (ModifyListView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showAddCluster ?
                     (AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showModifyCluster ?
                     (EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showAddContainer ?
                     (AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            .overlay(detailManager.showModifyContainer ?
                     (EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            .overlay(detailManager.showContent ? detailManager.content.animation(.default, value: detailManager.showContent) : nil)
            .overlay(detailManager.showSecondaryContent ? detailManager.secondaryContent.animation(.default, value: detailManager.showSecondaryContent) : nil)
    }
}






