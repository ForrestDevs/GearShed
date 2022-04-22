//
//  ItemRowView-InGearlist.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
import SwiftUI

struct ItemRowView_InGearlist: View {
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject private var gearlist: Gearlist
    @ObservedObject private var item: Item
    private var persistentStore: PersistentStore
    @State var itemPile: Pile?
    @State var previousItemPile: Pile?
    @State var itemPack: Pack?
    @State var previousItemPack: Pack?
    @State private var showDetailSheet: Bool = false
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        self.gearlist = gearlist
        self.item = item
        self.persistentStore = persistentStore
        
        let initialPile = item.gearlistPile(gearlist: gearlist)
        _itemPile = State(initialValue: initialPile)
        _previousItemPile = State(initialValue: initialPile)
        
        let initialPack = item.gearlistPack(gearlist: gearlist)
        _itemPack = State(initialValue: initialPack)
        _previousItemPack = State(initialValue: initialPack)
    }
    
    var body: some View {
        Button {
            //detailManager.selectedGearlist = adventure
            withAnimation {
                //detailManager.target = .showGearlistDetail
            }
        } label: {
            itemBody
        }
        .contextMenu {
            deleteContextButton
        }
//        .sheet(isPresented: $showDetailSheet) {
//            ItemDetailView(persistentStore: persistentStore, item: item)
//        }
        
    }
    
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
                
                /*if (persistentStore.stateUnit == "g") {
                    if (Int(item.weight) ?? 0 > 0) {
                        Text("\(item.weight) g")
                            .formatItemWeightBlack()
                        Text(", ")
                            .formatItemWeightBlack()
                    }
                }
                
                if (persistentStore.stateUnit == "lb + oz") {
                    if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
                        Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
                            .formatItemWeightBlack()
                        Text(", ")
                            .formatItemWeightBlack()
                    }
                }*/
                
                Text(item.detail)
                    .formatItemDetailsGrey()
            }
            .lineLimit(1)
            Divider()
        }
        .padding(.leading, 15)
        
        /*VStack (alignment: .leading, spacing: 2) {
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
                        .formatItemWeightBlack()
                }
                
                Text(item.detail)
                    .formatItemDetailsGrey()
                    .lineLimit(1)
            }
            Divider()
        }
        .padding(.top, 2)*/
        
        /*VStack (alignment: .leading, spacing: 3) {
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
                    //pileStatusLabel
                    //packStatusLabel
                }
            }
            Divider()
        }
        .padding(.leading, 15)*/
    }
    
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
    
    private var packStatusLabel: some View {
        if ((item.gearlistPack(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pack: " + (item.gearlistPack(gearlist: gearlist)!.name))
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
        if ((item.gearlistPile(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pile: " + (item.gearlistPile(gearlist: gearlist)!.name))
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
