//
//  DetailManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//
import SwiftUI

enum DetailTarget {
    case showAddItem, showItemDetail, showAddItemFromShed, showAddItemFromBrand, showModifyItem,
         showAddItemDiary, showModifyItemDiary, showItemDiaryDetail,
         showAddShed, showModifyShed,
         showAddBrand, showModifyBrand,
         showAddItemsToGearlist, showGearlistDetail,
         showAddAdventure, showModifyAdventure,
         showAddActivity, showModifyActivity,
         showAddActivityType, showModifyActivityType, showAddActivityFromActivityType,
         showAddCluster, showModifyCluster, showAddItemsToCluster,
         showAddContainer, showModifyContainer, showAddItemsToContainer,
         showContent, showSecondaryContent, noView
}

class DetailViewManager: ObservableObject {
    @Published var content: AnyView = AnyView(EmptyView())
    @Published var secondaryContent: AnyView = AnyView(EmptyView())
    
    @Published var target: DetailTarget = .noView
    @Published var secondaryTarget: DetailTarget = .noView
    @Published var tertiaryTarget: DetailTarget = .noView

    @Published var selectedItem: Item? = nil
    @Published var selectedItemDiary: ItemDiary? = nil
    @Published var selectedShed: Shed? = nil
    @Published var selectedBrand: Brand? = nil
    @Published var selectedGearlist: Gearlist? = nil
    @Published var selectedActivityType: ActivityType?
    @Published var selectedCluster: Cluster? = nil
    @Published var selectedContainer: Container? = nil

    init() {}
}


struct DetailOverlay: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var detailManager: DetailViewManager
    var type: DetailTarget
    var type2: DetailTarget
    var type3: DetailTarget
    var body: some View {
        ZStack {
            VStack {
                switch type {
            case .showAddItem:
                AddItemView(persistentStore: persistentStore, standard: true)
            case .showItemDetail:
                ItemDetailView(persistentStore: persistentStore, item: detailManager.selectedItem!)
            case .showAddItemFromShed:
                AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
            case .showAddItemFromBrand:
                AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
            case .showModifyItem:
                ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
            case .showAddItemDiary:
                AddItemDiaryView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyItemDiary:
                ModifyItemDiaryView(persistentStore: persistentStore, diary: detailManager.selectedItemDiary!)
            case .showItemDiaryDetail:
                ItemDiaryDetailView(diary: detailManager.selectedItemDiary!)
            case .showAddShed:
                AddShedView(persistentStore: persistentStore)
            case .showModifyShed:
                ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
            case .showAddBrand:
                AddBrandView(persistentStore: persistentStore)
            case .showModifyBrand:
                ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
            case .showAddItemsToGearlist:
                AddItemsToGearListView(persistentStore: persistentStore, type: .gearlistItem, gearlist: detailManager.selectedGearlist!)
            case .showGearlistDetail:
                GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showAddAdventure:
                AddAdventureView(persistentStore: persistentStore)
            case .showModifyAdventure:
                ModifyAdventureView(persistentStore: persistentStore, adventure: detailManager.selectedGearlist!)
            case .showAddActivity:
                AddActivityView(persistentStore: persistentStore)
            case .showModifyActivity:
                ModifyActivityView(persistentStore: persistentStore, activity: detailManager.selectedGearlist!)
            case .showAddActivityType:
                AddActivityTypeView(persistentStore: persistentStore)
            case .showModifyActivityType:
                ModifyActivityTypeView(persistentStore: persistentStore, activityType: detailManager.selectedActivityType!)
            case .showAddActivityFromActivityType:
                AddActivityView(persistentStore: persistentStore, activityTypeIn: detailManager.selectedActivityType!)
            case .showAddCluster:
                AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyCluster:
                EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
            case .showAddItemsToCluster:
                AddItemsToGearListView(persistentStore: persistentStore, type: .pileItem, gearlist: detailManager.selectedGearlist!, pile: detailManager.selectedCluster!)
            case .showAddContainer:
                AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyContainer:
                EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
            case .showAddItemsToContainer:
                AddItemsToGearListView(persistentStore: persistentStore, type: .packItem, gearlist: detailManager.selectedGearlist!, pack: detailManager.selectedContainer!)
            case .showContent:
                detailManager.content
            case .showSecondaryContent:
                detailManager.secondaryContent
            case .noView:
                EmptyView().opacity(0)
                }
            }
            VStack {
                switch type2 {
            case .showAddItem:
                AddItemView(persistentStore: persistentStore, standard: true)
            case .showItemDetail:
                ItemDetailView(persistentStore: persistentStore, item: detailManager.selectedItem!)
            case .showAddItemFromShed:
                AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
            case .showAddItemFromBrand:
                AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
            case .showModifyItem:
                ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
            case .showAddItemDiary:
                AddItemDiaryView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyItemDiary:
                ModifyItemDiaryView(persistentStore: persistentStore, diary: detailManager.selectedItemDiary!)
            case .showItemDiaryDetail:
                ItemDiaryDetailView(diary: detailManager.selectedItemDiary!)
            case .showAddShed:
                AddShedView(persistentStore: persistentStore)
            case .showModifyShed:
                ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
            case .showAddBrand:
                AddBrandView(persistentStore: persistentStore)
            case .showModifyBrand:
                ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
            case .showAddItemsToGearlist:
                AddItemsToGearListView(persistentStore: persistentStore, type: .gearlistItem, gearlist: detailManager.selectedGearlist!)
            case .showGearlistDetail:
                GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showAddAdventure:
                AddAdventureView(persistentStore: persistentStore)
            case .showModifyAdventure:
                ModifyAdventureView(persistentStore: persistentStore, adventure: detailManager.selectedGearlist!)
            case .showAddActivity:
                AddActivityView(persistentStore: persistentStore)
            case .showModifyActivity:
                ModifyActivityView(persistentStore: persistentStore, activity: detailManager.selectedGearlist!)
            case .showAddActivityType:
                AddActivityTypeView(persistentStore: persistentStore)
            case .showModifyActivityType:
                ModifyActivityTypeView(persistentStore: persistentStore, activityType: detailManager.selectedActivityType!)
            case .showAddActivityFromActivityType:
                AddActivityView(persistentStore: persistentStore, activityTypeIn: detailManager.selectedActivityType!)
            case .showAddCluster:
                AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyCluster:
                EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
            case .showAddItemsToCluster:
                AddItemsToGearListView(persistentStore: persistentStore, type: .pileItem, gearlist: detailManager.selectedGearlist!, pile: detailManager.selectedCluster!)
            case .showAddContainer:
                AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyContainer:
                EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
            case .showAddItemsToContainer:
                AddItemsToGearListView(persistentStore: persistentStore, type: .packItem, gearlist: detailManager.selectedGearlist!, pack: detailManager.selectedContainer!)
            case .showContent:
                detailManager.content
            case .showSecondaryContent:
                detailManager.secondaryContent
            case .noView:
                EmptyView().opacity(0)
                }
            }
            VStack {
                switch type3 {
            case .showAddItem:
                AddItemView(persistentStore: persistentStore, standard: true)
            case .showItemDetail:
                ItemDetailView(persistentStore: persistentStore, item: detailManager.selectedItem!)
            case .showAddItemFromShed:
                AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
            case .showAddItemFromBrand:
                AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
            case .showModifyItem:
                ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
            case .showAddItemDiary:
                AddItemDiaryView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyItemDiary:
                ModifyItemDiaryView(persistentStore: persistentStore, diary: detailManager.selectedItemDiary!)
            case .showItemDiaryDetail:
                ItemDiaryDetailView(diary: detailManager.selectedItemDiary!)
            case .showAddShed:
                AddShedView(persistentStore: persistentStore)
            case .showModifyShed:
                ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
            case .showAddBrand:
                AddBrandView(persistentStore: persistentStore)
            case .showModifyBrand:
                ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
            case .showAddItemsToGearlist:
                AddItemsToGearListView(persistentStore: persistentStore, type: .gearlistItem, gearlist: detailManager.selectedGearlist!)
            case .showGearlistDetail:
                GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showAddAdventure:
                AddAdventureView(persistentStore: persistentStore)
            case .showModifyAdventure:
                ModifyAdventureView(persistentStore: persistentStore, adventure: detailManager.selectedGearlist!)
            case .showAddActivity:
                AddActivityView(persistentStore: persistentStore)
            case .showModifyActivity:
                ModifyActivityView(persistentStore: persistentStore, activity: detailManager.selectedGearlist!)
            case .showAddActivityType:
                AddActivityTypeView(persistentStore: persistentStore)
            case .showModifyActivityType:
                ModifyActivityTypeView(persistentStore: persistentStore, activityType: detailManager.selectedActivityType!)
            case .showAddActivityFromActivityType:
                AddActivityView(persistentStore: persistentStore, activityTypeIn: detailManager.selectedActivityType!)
            case .showAddCluster:
                AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyCluster:
                EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
            case .showAddItemsToCluster:
                AddItemsToGearListView(persistentStore: persistentStore, type: .pileItem, gearlist: detailManager.selectedGearlist!, pile: detailManager.selectedCluster!)
            case .showAddContainer:
                AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
            case .showModifyContainer:
                EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
            case .showAddItemsToContainer:
                AddItemsToGearListView(persistentStore: persistentStore, type: .packItem, gearlist: detailManager.selectedGearlist!, pack: detailManager.selectedContainer!)
            case .showContent:
                detailManager.content
            case .showSecondaryContent:
                detailManager.secondaryContent
            case .noView:
                EmptyView().opacity(0)
                }
            }
        }
        .environmentObject(persistentStore)
        .environmentObject(detailManager)
    }
}
