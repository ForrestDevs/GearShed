//
//  ItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
	@ObservedObject var item: Item
    
    @State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    
	var body: some View {
        ZStack {
            Color.clear
            Button {
                detailManager.selectedItem = item
                withAnimation {
                    detailManager.showItemDetail = true
                }
            } label: {
                itemBody
            }
        }
        .contextMenu {
            favContextButton
            regretContextButton
            wishContextButton
            editContextButton
            deleteContextButton
        }
        .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
    }
}

extension ItemRowView {
    
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
    
    private var itemBody: some View {
        HStack {
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
                        Text("\(item.weight) g")
                            .formatItemWeightBlack()
                        Text("|")
                            .formatItemWeightBlack()
                        Text("$ \(item.price)")
                            .formatItemPriceGreen()
                    }
                    
                    Text(item.detail)
                        .formatItemDetailsGrey()
                        .lineLimit(1)
                }
            }
            Spacer()
        }
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
                    Text("Remove from Favourite")
                    Image(systemName: "heart.fill")
                }
                
            } else {
                HStack {
                    Text("Add to Favourite")
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
                    Text("Remove from Regret")
                    Image(systemName: "hand.thumbsdown.fill")
                }
                
            } else {
                HStack {
                    Text("Add to Regret")
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
                    Text("Remove from Wishlist")
                    Image(systemName: "star.fill")
                }
            } else {
                HStack {
                    Text("Add to Wishlist")
                    Image(systemName: "star.fill")
                }
            }
        }
    }
    
    private var editContextButton: some View {
        Button {
            detailManager.selectedItem = item
            withAnimation {
                detailManager.showModifyItem = true
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
            confirmDeleteItemAlert = ConfirmDeleteItemAlert (
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

/*private var favouriteButton: some View {
    Image(systemName: item.isFavourite ? "heart.fill" : "heart")
        .resizable()
        .frame(width: 13, height: 12)
        .foregroundColor(Color.theme.green)
        .padding(.vertical, -1)
        .onTapGesture {
            if item.isFavourite {
                item.unmarkFavourite()
            } else {
                item.markFavourite()
                item.unmarkRegret()
            }
        }
}*/


















