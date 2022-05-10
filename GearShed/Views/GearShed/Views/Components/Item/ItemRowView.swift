//
//  ItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var vm: GearShedViewModel
	@ObservedObject var item: Item
	var body: some View {
        Button {
            detailManager.selectedItem = item
            withAnimation {
                detailManager.target = .showItemDetail
            }
        } label: {
            itemBody
        }
        .contextMenu {
            favContextButton
            regretContextButton
            wishContextButton
            editContextButton
            deleteContextButton
        }
    }
}

extension ItemRowView {
    //MARK: View Components
    private var statusIcon: some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 2)
            } else
            if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.regretColor)
                    .padding(.horizontal, 2)
            } else
            if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.yellow)
                    .padding(.horizontal, 2)
            }
        }
    }
    private var itemBody: some View {
        VStack (alignment: .leading, spacing: 2) {
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
            VStack (alignment: .leading, spacing: 2) {
                HStack {
                    if (Prefs.shared.weightUnit == "g") {
                        if (Int(item.weight) ?? 0 > 0) {
                            Text("\(item.weight) g")
                                .formatItemWeightBlack()
                        }
                    }
                    if (Prefs.shared.weightUnit == "lb + oz") {
                        if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
                            Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
                                .formatItemWeightBlack()
                        }
                    }
                    Text("|")
                        .formatItemWeightBlack()
                    Text("$ \(item.price)")
                        .formatItemWeightBlack()
                }
                Text(item.detail)
                    .formatItemDetailsGrey()
                    .lineLimit(1)
            }
            Divider()
        }
        .padding(.top, 2)
    }
    // MARK: Context Menus
    private var favContextButton: some View {
        Button {
            if item.isFavourite {
                item.unmarkFavourite()
                persistentStore.saveContext()
            } else {
                item.markFavourite()
                persistentStore.saveContext()
            }
        } label: {
            if item.isFavourite {
                HStack {
                    Text("Remove Gear from Favourite")
                    Image(systemName: "heart.fill")
                }
                
            } else {
                HStack {
                    Text("Add Gear to Favourite")
                    Image(systemName: "heart.fill")
                }
            }
        }
    }
    private var regretContextButton: some View {
        Button {
            if item.isRegret {
                item.unmarkRegret()
                persistentStore.saveContext()
            } else {
                item.markRegret()
                persistentStore.saveContext()
            }
        } label: {
            if item.isRegret {
                HStack {
                    Text("Remove Gear from Regret")
                    Image(systemName: "hand.thumbsdown.fill")
                }
                
            } else {
                HStack {
                    Text("Add Gear to Regret")
                    Image(systemName: "hand.thumbsdown.fill")
                }
            }
        }
    }
    private var wishContextButton: some View {
        Button {
            if item.isWishlist {
                item.unmarkWish()
                persistentStore.saveContext()
            } else {
                item.markWish()
                persistentStore.saveContext()
            }
        } label: {
            if item.isWishlist {
                HStack {
                    Text("Remove Gear from Wishlist")
                    Image(systemName: "star.fill")
                }
            } else {
                HStack {
                    Text("Add Gear to Wishlist")
                    Image(systemName: "star.fill")
                }
            }
        }
    }
    private var editContextButton: some View {
        Button {
            detailManager.selectedItem = item
            withAnimation {
                detailManager.secondaryTarget = .showModifyItem
            }
        } label: {
            HStack {
                Text("Edit Gear")
                Image(systemName: "square.and.pencil")
            }
            
        }
    }
    private var deleteContextButton: some View {
        Button {
            vm.confirmDeleteItemAlert = ConfirmDeleteItemAlert (
                persistentStore: persistentStore,
                item: item,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Gear")
                Image(systemName: "trash")
            }
        }
    }
}
