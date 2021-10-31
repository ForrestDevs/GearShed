//
//  AllItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllItemsView: View {
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData
    
    @State private var selectedShed: Shed? = nil 
    @State private var showingUnlockView: Bool = false
    @State private var isAddItemShowing: Bool = false
    @State private var isQuickAddItemShowing: Bool = false
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
                itemList
                addItemOverlay
            }
        }
        .fullScreenCover(isPresented: $isAddItemShowing) {
            AddItemView(persistentStore: persistentStore)
                .environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .fullScreenCover(isPresented: $isQuickAddItemShowing) {
            AddItemView(persistentStore: persistentStore, shed: selectedShed).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .sheet(isPresented: $showingUnlockView) {
            UnlockView()
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                Text("\(viewModel.items.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(viewModel.totalWeight(array: viewModel.items))g")
            }
            HStack {
                Text("Invested:")
                Text("$\(viewModel.totalCost(array: viewModel.items))")
            }
            Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
    
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.sectionByShed(itemArray: viewModel.items)) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRowView(item: item)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                        }
                    } header: {
                        sectionHeader(section: section)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 75)
        }
    }
    
    private func sectionHeader(section: SectionShedData) -> some View {
       return VStack (spacing: 0) {
            HStack {
                Button {
                    selectedShed = section.shed
                    let canCreate = self.persistentStore.fullVersionUnlocked ||
                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                    if canCreate {
                        isQuickAddItemShowing.toggle()
                    } else {
                        showingUnlockView.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                
                Text(section.title)
                    .font(.headline)
                Spacer()
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
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
                        Text("Item")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 75)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
}










