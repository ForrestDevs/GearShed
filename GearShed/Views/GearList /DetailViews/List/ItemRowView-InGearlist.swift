//
//  ItemRowView-InGearlist.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ItemRowView_InGearlist: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject private var gearlist: Gearlist
    @ObservedObject private var item: Item
    
    @State var itemCluster: Cluster?
    @State var previousItemCluster: Cluster?
    @State var itemContainer: Container?
    @State var previousItemContainer: Container?
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        self.gearlist = gearlist
        self.item = item
        
        let initialCluster = item.gearlistCluster(gearlist: gearlist)
        _itemCluster = State(initialValue: initialCluster)
        _previousItemCluster = State(initialValue: initialCluster)
        
        let initialContainer = item.gearlistContainer(gearlist: gearlist)
        _itemContainer = State(initialValue: initialContainer)
        _previousItemContainer = State(initialValue: initialContainer)
    }
    
    var body: some View {
        itemBody
        .contextMenu {
            addItemDiaryButton
            deleteContextButton
        }
        
    }
}

extension ItemRowView_InGearlist {
    
    private var itemBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                HStack {
                    HStack (spacing: 5) {
                        Text(item.name)
                            .formatItemNameGreen()
                            .fixedSize()
                        statusIcon
                    }
                    Text("|")
                        .formatItemNameBlack()
                    Text(item.brandName)
                        .formatItemNameBlack()
                }
                .lineLimit(1)
                HStack (spacing: 20) {
                    Text(item.weight + "g")
                        .formatItemWeightBlack()
                    HStack {
                        pileStatusLabel
                        packStatusLabel
                    }
                }
            }
            Spacer()
        }
        
    }
    
    private var statusIcon: some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            } else
            if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            } else
            if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.green)
                    .padding(.horizontal, 2)
            }
        }
    }
    
    private var packStatusLabel: some View {
        if ((item.gearlistContainer(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pack: " + (item.gearlistContainer(gearlist: gearlist)!.name))
                    .formatItemWeightBlack()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        } else {
            return AnyView (
                Text ("Pack: ")
                    .formatItemWeightBlack()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        }
    }
    
    private var pileStatusLabel: some View {
        if ((item.gearlistCluster(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pile: " + (item.gearlistCluster(gearlist: gearlist)!.name))
                    .formatItemWeightBlack()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        } else {
            return AnyView (
                Text("Pile: ")
                    .formatItemWeightBlack()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        }
    }
    
    // MARK: Context Menus
    private var deleteContextButton: some View {
        Button {
            withAnimation {
                viewModel.removeItemFromGearlist(item: item, gearlist: gearlist)
            }
        } label: {
            HStack {
                Text("Remove From List")
                Image(systemName: "trash")
            }
        }
    }
    
    private var addItemDiaryButton: some View {
        Button {
            detailManager.selectedGearlist = gearlist
            detailManager.selectedItem = item
            withAnimation {
                detailManager.showAddItemDiary = true
            }
        } label: {
            HStack {
                Text("Add Gear Diary")
                Image(systemName: "plus")
            }
        }
        
    }
    
}
