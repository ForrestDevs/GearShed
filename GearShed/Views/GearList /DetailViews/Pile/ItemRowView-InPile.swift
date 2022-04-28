//
//  ItemRowView-InPile.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemRowViewInPile: View {
    @EnvironmentObject private var viewModel: GearlistData
    @EnvironmentObject private var persistentStore: PersistentStore
    @ObservedObject var item: Item
    private var gearlist: Gearlist?
    private var pile: Pile?
    
    var body: some View {
        ZStack {
            Color.clear
            itemBody
        }
        .contextMenu {
            if pile == nil {
                moveToPile
            } else {
                deleteContextButton
            }
        }
    }
}

extension ItemRowViewInPile {
    /// Intitalizer for passing in only a gearlist and an item to find specifc pile
    init(gearlist: Gearlist, item: Item) {
        self.gearlist = gearlist
        self.item = item
    }
    /// Initializer for passing in a specifc pile and item
    init(pile: Pile, item: Item) {
        self.pile = pile
        self.item = item
    }
    //MARK: Main Content
    private var itemBody: some View {
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
            HStack (spacing: 0) {
                if (Prefs.shared.weightUnit == "g") {
                    if (Int(item.weight) ?? 0 > 0) {
                        Text("\(item.weight) g")
                            .formatItemWeightBlack()
                        Text(", ")
                            .formatItemWeightBlack()
                    }
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
                        Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
                            .formatItemWeightBlack()
                        Text(", ")
                            .formatItemWeightBlack()
                    }
                }
                Text(item.detail)
                    .formatItemDetailsGrey()
            }
                .lineLimit(1)
            Divider()
        }
            .padding(.leading, 15)
    }
    private var statusIcon: some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 2)
            } else if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.regretColor)
                    .padding(.horizontal, 2)
            } else if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.yellow)
                    .padding(.horizontal, 2)
            }
        }
    }
    private var moveToPile: some View {
        ForEach(gearlist!.piles) { pile in
            Button {
                viewModel.updateItemPile(newPile: pile, oldPile: nil, item: item)
            } label: {
                Text(pile.name)
            }
        }
    }
    private var deleteContextButton: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation {
                    viewModel.removeItemFromPile(item: item, pile: pile!)
                }
            })
        } label: {
            HStack {
                Text("Remove From Pile")
                Image(systemName: "trash")
            }
        }
    }
}
