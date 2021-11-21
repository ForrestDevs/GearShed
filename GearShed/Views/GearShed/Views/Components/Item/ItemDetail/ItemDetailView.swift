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
                HStack {
                    titleBar
                    AddImageButton(item: item)
                        .environmentObject(gsData)
                }
                
                HStack {
                    itemDetails
                }
                .padding(.horizontal)
                ItemDetailPageView(item: item)
                    .environmentObject(glData)
                    .environmentObject(gsData)
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
    
    // MARK: Main
    private var titleBar: some View {
        // Fav, Brand, Name
        HStack {
            if item.isFavourite_ {
                favouriteButton
            } else if item.isRegret_ {
                regretButton
            } else {
                spaceFiller
            }
            
            Text(item.brandName)
                .formatBlackTitle()
            
            Text("|")
                .formatBlackTitle()
            
            Text(item.name)
                .formatGreenTitle()
            
            Spacer()

        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
    
    private var itemDetails: some View {
        HStack {
            VStack (alignment: .leading, spacing: 5) {
                // Weight - Price
                HStack {
                    spaceFiller
                    HStack {
                        Text("Weight:")
                            .formatBlackSmall()
                        
                        Text("\(item.weight)g")
                            .formatGreenSmall()
                    }
                    HStack {
                        Text("Price:")
                            .formatBlackSmall()
                        
                        Text("$\(item.price)")
                            .formatGreenSmall()
                    }
                }
                
                // Purchased - Regret
                HStack {
                    spaceFiller
                    HStack {
                        Text("Purchased:")
                            .formatBlackSmall()
                        
                        //Text()
                        Text(item.datePurchased?.asShortDateString() ?? "" )
                            .formatGreenSmall()
                    }
                    HStack {
                        Text("Regret")
                            .formatBlackSmall()
                        regretButton
                    }
                }
                
                // Details
                HStack {
                    spaceFiller
                    Text(item.detail)
                        .formatGreenSmall()
                        .frame(alignment: .leading)
                }
            }
            Spacer()
        }
    }
    
    private var pageView: some View {
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
    
    private var favouriteButton: some View {
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
    }
}


struct ItemDetailPageView: View {
    
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
    
}
















