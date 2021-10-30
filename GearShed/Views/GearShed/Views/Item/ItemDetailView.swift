//
//  ItemDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager
    
    @ObservedObject var item: Item
    
    @State private var isEditItemShowing: Bool = false
    @State private var currentSelection: Int = 0
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                titleBar
                secondaryBar
                //detailsBar
            }
            .padding(.horizontal)
            pageView
        }
        .navigationTitle("\(item.shedName)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { self.isEditItemShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditItemShowing) {
            ModifyItemView(persistentStore: persistentStore,editableItem: item).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .onAppear {
            tabManager.hideTab = true
        }
    }
    
    private var favouriteButton: some View {
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
    }
    
    private var regretButton: some View {
        Image(systemName: item.isRegret ? "circle.fill" : "circle")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            .onTapGesture {
                if item.isRegret {
                    item.unmarkRegret()
                } else {
                    item.markRegret()
                    item.unmarkFavourite()
                }
            }
    }
    
    private var titleBar: some View {
        // Fav, Brand, Name
        HStack {
            favouriteButton
            
            Text(item.brandName)
                .formatBlack()
            
            Text("|")
                .formatBlack()
            
            Text(item.name)
                .formatGreen()
            
            Spacer()

        }
    }
    
    private var secondaryBar: some View {
        HStack (alignment: .top , spacing: 5) {
            
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray)
            
            VStack (alignment: .leading, spacing: 5) {
                // Weight - Price
                HStack {
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
                    HStack {
                        Text("Purchased:")
                            .formatBlackSmall()
                        
                        Text("\(item.datePurchased.asShortDateString())")
                            .formatGreenSmall()
                    }
                    HStack {
                        Text("Regret")
                            .formatBlackSmall()
                        regretButton
                    }
                }
                
                // Details
                Text(item.detail)
                    .formatGreenSmall()
                    .frame(alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var detailsBar: some View {
        HStack {
            Text(item.detail)
                .formatGreenSmall()
                .frame(alignment: .leading)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var pageView: some View {
        PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
            Text("TRIP")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("LIST")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("DIARY")
                .pageLabel()
                .font(.system(size: 12).bold())
            Text("PHOTO")
                .pageLabel()
                .font(.system(size: 12).bold())
        } content: {
            Color.green
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.blue
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.red
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.black
                .pageView(ignoresSafeArea: true, edges: .bottom)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}


