//
//  ItemDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @ObservedObject var item: Item
    
    @State private var isEditItemShowing: Bool = false
    @State private var currentSelection: Int = 0
        
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                titleBar
                HStack {
                    itemDetails
                    itemImage
                }
                .padding(.horizontal)
                pageView
            }
            .navigationBarTitle("\(item.shedName)", displayMode: .inline)
            .toolbar {
                editButton
                backButton
            }
            .fullScreenCover(isPresented: $isEditItemShowing) {
                ModifyItemView(persistentStore: persistentStore,editableItem: item)
                    .environment(\.managedObjectContext, persistentStore.context)
            }
        }
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
    
    private var itemImage: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray)
            
            Text("Image N/a")
        }
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
        .padding(.top, 10)
    }
    
    // MARK: Extras
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    
    private var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isEditItemShowing.toggle()
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
            /*.onTapGesture {
                if item.isFavourite {
                    item.unmarkFavourite()
                } else {
                    item.markFavourite()
                    item.unmarkRegret()
                }
            }*/
    }
    
    private var regretButton: some View {
        Image(systemName: "hand.thumbsdown.fill")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            /*.onTapGesture {
                if item.isRegret {
                    item.unmarkRegret()
                } else {
                    item.markRegret()
                    item.unmarkFavourite()
                }
            }*/
    }
    
    private var spaceFiller: some View {
        Image(systemName: "heart")
            .resizable()
            .frame(width: 13, height: 12)
            .padding(.vertical, -1)
            .opacity(0)
    }
}


