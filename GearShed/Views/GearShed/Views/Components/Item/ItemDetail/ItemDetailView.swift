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
    
    @State private var currentSelection: Int = 0
    
    init(persistentStore: PersistentStore, item: Item) {
        self.item = item
        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
    }

    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                viewContent
                ItemDiaryList(item: item)
                //pageView
                /*HStack {
                    titleBar
                    AddImageButton(item: item)
                        .environmentObject(gsData)
                }
                
                HStack {
                    itemDetails
                }
                .padding(.horizontal)
                pageView*/
                /*ItemDetailPageView(item: item)
                    .environmentObject(glData)
                    .environmentObject(gsData)*/
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                editButton
                viewTitle
                backButton
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension ItemDetailView {
    
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
    
    private var itemDetails: some View {
        HStack (alignment: .top) {
            VStack (alignment: .leading, spacing: 2) {
                HStack {
                    if let weight = item.weight {
                        Text("\(weight)g")
                            .formatDetailsWPPBlack()
                    }
                    if let price = item.price {
                        Text("$\(price)")
                            .formatDetailsWPPBlack()
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
            ItemImageView(item: item)
                .environmentObject(gsData)
        }
        .padding(.trailing)

        
        /*HStack {
            VStack (alignment: .leading, spacing: 5) {
                // Weight - Price
                HStack {
                    spaceFiller
                    
                }
                
                // Purchased - Regret
                HStack {
                    spaceFiller
                    
                    HStack {
                        Text("Regret")
                            .formatBlackSmall()
                        regretButton
                    }
                }
                
                // Details
                HStack {
                    spaceFiller
                    
                        .frame(alignment: .leading)
                }
            }
            Spacer()
        }*/
    }
    
    private var pageView: some View {
        PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
            Text("Photo")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("Diary")
                .pageLabel()
                .font(.system(size: 12).bold())
        } content: {
            ItemImageView(item: item)
                .environmentObject(gsData)
                .pageView()
            ItemDiaryList(item: item)
                .pageView()
            /*ItemAdventureList(item: item)
                .environmentObject(glData)
                .pageView()
            ItemActivityList(item: item)
                .environmentObject(glData)
                .pageView()*/
        }
    }
    
    // MARK: Extras
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showItemDetail = false
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
    
    private var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                detailManager.selectedItem = item
                withAnimation {
                    detailManager.showModifyItem = true
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
        }
    }
    
    /*private var favouriteButton: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
    }
    
    private var regretButton: some View {
        Image(systemName: "hand.thumbsdown.fill")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
    }
    
    private var spaceFiller: some View {
        Image(systemName: "heart")
            .resizable()
            .frame(width: 13, height: 12)
            .padding(.vertical, -1)
            .opacity(0)
    }*/
}


/*struct ItemDetailPageView: View {
    
    @EnvironmentObject private var glData: GearlistData
    @EnvironmentObject private var gsData: GearShedData
    
    @ObservedObject var item: Item

    @State private var currentSelection: Int = 0
    
    var body: some View {
        PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
            Text("Adventures")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("Activities")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("Diaries")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("Photo")
                .pageLabel()
                .font(.system(size: 12).bold())
        } content: {
            ItemAdventureList(item: item)
                .environmentObject(glData)
                .pageView()
            ItemActivityList(item: item)
                .environmentObject(glData)
                .pageView()
            ItemDiaryList(item: item)
                .pageView()
            ItemImageView(item: item)
                .environmentObject(gsData)
                .pageView()
        }
    }
    
}*/
















