//
//  ItemDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @ObservedObject private var item: Item
    @StateObject private var glData: GearlistData
    @StateObject private var gsData: GearShedData
            
    init(persistentStore: PersistentStore, item: Item) {
        self.item = item
        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        
        self.persistentStore = persistentStore
    }
    
    let persistentStore: PersistentStore

    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                viewContent
                ItemDiaryList(item: item)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //editButton
                viewTitle
                backButton
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    private var viewContent: some View {
        VStack(alignment: .leading, spacing: 5) {
            titleBar
            itemDetails
        }
        .padding(.leading, 25)
    }
    
    // MARK: Main
    private var titleBar: some View {
        HStack {
            HStack (spacing: 5) {
                Text(item.name)
                    .formatGreenTitle()
                    .fixedSize()
                statusIcon
            }
            Text("|")
                .formatBlackTitle()
            Text(item.brandName)
                .formatBlackTitle()
            Spacer()
        }
        .lineLimit(1)
        .padding(.top, 20)
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
    
    private var itemDetails: some View {
        HStack (alignment: .top) {
            VStack (alignment: .leading, spacing: 2) {
                HStack {
                    if (Prefs.shared.weightUnit == "g") {
                        if let weight = item.weight {
                            if Int(weight) ?? 0 > 0 {
                                Text("\(weight) g")
                                    .formatDetailsWPPBlack()
                            }
                        }
                    }
                    if (Prefs.shared.weightUnit == "lb + oz") {
                        if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
                            Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
                                .formatDetailsWPPBlack()
                        }
                    }
                    if let price = item.price {
                        if Int(price) ?? 0 > 0 {
                            Text("$ \(price)")
                                .formatDetailsWPPBlack()
                        }
                    }
                }
                HStack {
                    if let date = item.datePurchased {
                        Text("Purchased:")
                            .formatDetailsWPPBlack()
                        Text(date.dateText(style: .medium))
                            .formatDetailsWPPBlack()
                    }
                }
                Text(item.detail)
                        .formatDetailDescriptionBlack()
            }
            Spacer()
        }
        .padding(.trailing)
    }
    
    // MARK: Extras
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text(item.shedName)
                .formatGreen()
        }
    }
}


/*
 ItemImageView(item: item)
     .contextMenu {
         addEditButton
         
         if item.image != nil {
             deleteImageButton
         }
     }
     .environmentObject(gsData)
 
 
 // MARK: Item Image Context Menus
 private var addEditButton: some View {
     AddImageButton(item: item)
         .environmentObject(gsData)
 }
 
 private var deleteImageButton: some View {
     Button {
         gsData.deleteItemImg(item: item)
     } label: {
         HStack {
             Text("Delete Image")
             Image(systemName: "trash")
         }
     }
 }
 
 
 private var editButton: some ToolbarContent {
     ToolbarItem(placement: .navigationBarTrailing) {
         Button {
             detailManager.selectedItem = item
             withAnimation {
                 detailManager.secondaryTarget = .showModifyItem
             }
         } label: {
             Image(systemName: "slider.horizontal.3")
         }
     }
 }
 
 /*if (persistentStore.stateUnit == "g") {
     if let weight = item.weight {
         if Int(weight) ?? 0 > 0 {
             Text("\(weight) g")
                 .formatDetailsWPPBlack()
         }
     }
 }
 
 if (persistentStore.stateUnit == "lb + oz") {
     if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
         Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
             .formatDetailsWPPBlack()
     }
 }*/
 */
