//
//  ItemRowViewInGearlist.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemRowViewInGearlist: View {
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject private var gearlist: Gearlist
    @ObservedObject private var item: Item
    @State var itemPile: Pile?
    @State var previousItemPile: Pile?
    @State var itemPack: Pack?
    @State var previousItemPack: Pack?
    private let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        let initialPile = item.gearlistPile(gearlist: gearlist)
        _itemPile = State(initialValue: initialPile)
        _previousItemPile = State(initialValue: initialPile)
        let initialPack = item.gearlistPack(gearlist: gearlist)
        _itemPack = State(initialValue: initialPack)
        _previousItemPack = State(initialValue: initialPack)
        self.gearlist = gearlist
        self.item = item
        self.persistentStore = persistentStore
    }
    
    var body: some View {
        itemBody
        .contextMenu {
            deleteContextButton
        }
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
    // MARK: Context Menus
    private var deleteContextButton: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation {
                    viewModel.removeItemFromGearlist(item: item, gearlist: gearlist)
                }
            })
        } label: {
            HStack {
                Text("Remove From List")
                Image(systemName: "trash")
            }
        }
    }
}

