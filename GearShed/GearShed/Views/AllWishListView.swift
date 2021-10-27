//
//  AllWishListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllWishListView: View {

    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData
    
    @State private var showingUnlockView: Bool = false
    
    @State private var isAddItemShowing: Bool = false
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newItemName: String = ""
    
    @State private var item1: Item? = nil
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                itemsList
                addItemOverlay
            }
            .padding(.bottom, 50)
        }
        .fullScreenCover(isPresented: $isAddItemShowing) {
            AddItemView(persistentStore: persistentStore, wishlist: true)
                .environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .sheet(isPresented: $showingUnlockView) {
            UnlockView()
        }
    }
    
    
    private var statBar: some View {
        HStack (spacing: 30) {
            HStack {
                Text("Items:")
                Text("\(viewModel.wishListItems.count)")
            }
            HStack {
                Text("Cost:")
                Text("$\(viewModel.totalCost(array: viewModel.wishListItems))")
            }
             Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.vertical, 5)
        .offset(x: 45)
        .background(Color.theme.green)
        .padding(.vertical, 15)
    }
    
    private var itemsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.sectionByShed(itemArray: viewModel.wishListItems)) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowViewInWishList(item: item)
                            .padding(.bottom, 5)
                    }
                } header: {
                    VStack (spacing: 0) {
                        HStack {
                            Text(section.title)
                                .font(.headline)
                            Spacer()
                        }
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                }
            }
        }

    }
    
    private var addItemOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    let canCreate = self.persistentStore.fullVersionUnlocked ||
                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                    if canCreate {
                        isAddItemShowing.toggle()
                    } else {
                        showingUnlockView.toggle()
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Wish")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
}





