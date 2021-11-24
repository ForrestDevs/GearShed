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
        
            // MARK: Gear Item Stuff -----------------------------------
            // Standard Add Item
            .overlay(detailManager.showAddItem ?
                     (AddItemView(persistentStore: persistentStore, standard: true)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Add item with selected shed initialized
            .overlay(detailManager.showAddItemFromShed ?
                     (AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Add item with selected brand initialized
            .overlay(detailManager.showAddItemFromBrand ?
                     (AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            
            // Item detail view
            .overlay(detailManager.showItemDetail ?
                     (ItemDetailView(persistentStore: persistentStore, item: detailManager.selectedItem!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify Item View
            .overlay(detailManager.showModifyItem ?
                     (ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            // Item Diary DetailView
            .overlay(detailManager.showItemDiaryDetail ?
                     (ItemDiaryDetailView(diary: detailManager.selectedItemDiary!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            // MARK: SHED Stuff -----------------------------------
            // Standard add shed.
            .overlay(detailManager.showAddShed ?
                     (AddShedView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify Shed view
            .overlay(detailManager.showModifyShed ?
                     (ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Brand Stuff -----------------------------------
            // Standard Add Brand
            .overlay(detailManager.showAddBrand ?
                     (AddBrandView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify Brand View
            .overlay(detailManager.showModifyBrand ?
                     (ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Adventure Stuff -------------------------------------
            // Standard Add New Adventure
            .overlay(detailManager.showAddAdventure ?
                     (AddAdventureView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify existing Adventure
            .overlay(detailManager.showModifyAdventure ?
                     (ModifyAdventureView(persistentStore: persistentStore, adventure: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Activity Stuff -------------------------------------
            // Standard add Activity
            .overlay(detailManager.showAddActivity ?
                     (AddActivityView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Add Activity from type
            .overlay(detailManager.showAddActivityFromActivityType ?
                     (AddActivityView(persistentStore: persistentStore, activityTypeIn: detailManager.selectedActivityType!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify existing Adventure
            .overlay(detailManager.showModifyActivity ?
                     (ModifyActivityView(persistentStore: persistentStore, activity: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Activity Type Stuff -------------------------------------
            // Add new Activity Type
            .overlay(detailManager.showAddActivityType ?
                     (AddActivityTypeView(persistentStore: persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify Existing Activity Type
            .overlay(detailManager.showModifyActivityType ?
                     (ModifyActivityTypeView(persistentStore: persistentStore, activityType: detailManager.selectedActivityType!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Gearlist Detail View Stuff --------------------------------------
            // Gearlist Detail View
            .overlay(detailManager.showGearlistDetail ?
                     (GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(persistentStore)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Add Item Diary View
            .overlay(detailManager.showAddItemDiary ?
                     (AddItemDiaryView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
        
            // Modify Item Diary View
            .overlay(detailManager.showModifyItemDiary ?
                     (ModifyItemDiaryView(persistentStore: persistentStore, diary: detailManager.selectedItemDiary!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Select items to add/ remove from gearlist view
            .overlay(detailManager.showAddItemsToGearlist ?
                     (AddItemsToGearListView(persistentStore: persistentStore, type: .gearlistItem, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Pile Stuff -----------------------------------------
            // Add new Pile View
            .overlay(detailManager.showAddCluster ?
                     (AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Modify pile name view
            .overlay(detailManager.showModifyCluster ?
                     (EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Select items to add/remove from pile view
            .overlay(detailManager.showAddItemsToCluster ?
                     (AddItemsToGearListView(persistentStore: persistentStore, type: .pileItem, gearlist: detailManager.selectedGearlist!, pile: detailManager.selectedCluster!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Pack Stuff -----------------------------------------
            // Add new Pack view
            .overlay(detailManager.showAddContainer ?
                     (AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Edit pack name view
            .overlay(detailManager.showModifyContainer ?
                     (EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
                        .environmentObject()
                        .environmentObject(detailManager)
                     ) : nil
            )
            // Select items to add/remove from pack
            .overlay(detailManager.showAddItemsToContainer ?
                     (AddItemsToGearListView(persistentStore: persistentStore, type: .packItem, gearlist: detailManager.selectedGearlist!, pack: detailManager.selectedContainer!)
                        .environmentObject(detailManager)
                     ) : nil
            )
            // MARK: Generic Overlay Views -----------------------------------------
            // First layer content
            .overlay(detailManager.showContent ? detailManager.content.animation(.default, value: detailManager.showContent) : nil)
            // Second layer content
            .overlay(detailManager.showSecondaryContent ? detailManager.secondaryContent.animation(.default, value: detailManager.showSecondaryContent) : nil)
    }
}






