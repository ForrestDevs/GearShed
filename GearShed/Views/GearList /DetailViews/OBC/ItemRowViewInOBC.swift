//
//  ItemRowViewInOBC.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-09-27.
//

import SwiftUI

enum OBCType {
    case onBody, baseWeight, consumable
}

struct ItemRowViewInOBC: View {
    @EnvironmentObject private var viewModel: GearlistData
    @EnvironmentObject private var persistentStore: PersistentStore
    @ObservedObject var item: Item
    @State var type: OBCType
    private var gearlist: Gearlist
    
    var body: some View {
        ZStack {
            Color.clear
            itemBody
        }
        .contextMenu {
            deleteContextButton
        }
    }
}

extension ItemRowViewInOBC {
    /// Intitalizer for passing in only a gearlist and an item to find specifc pile
    init(gearlist: Gearlist, item: Item, type: OBCType) {
        self.gearlist = gearlist
        self.item = item
        self.type = type
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
    private var deleteContextButton: some View {
        VStack {
            switch type {
            case .onBody:
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation {
                            viewModel.removeItemFromOBC(item: item, gearlist: gearlist, type: .onBody)
                        }
                    })
                } label: {
                    HStack {
                        Text("Remove from On Body")
                        Image(systemName: "trash")
                    }
                }
            case .baseWeight:
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation {
                            viewModel.removeItemFromOBC(item: item, gearlist: gearlist, type: .baseWeight)
                        }
                    })
                } label: {
                    HStack {
                        Text("Remove from Base Weight")
                        Image(systemName: "trash")
                    }
                }
            case .consumable:
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation {
                            viewModel.removeItemFromOBC(item: item, gearlist: gearlist, type: .consumable)
                        }
                    })
                } label: {
                    HStack {
                        Text("Remove from Consumable")
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

