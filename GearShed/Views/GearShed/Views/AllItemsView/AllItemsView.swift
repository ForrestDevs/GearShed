//
//  AllItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllItemsView: View {
    let persistentStore: PersistentStore
    
    @StateObject private var gsData: GearShedData
    @StateObject private var vm: AllItemsViewModel
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        
        let vm = AllItemsViewModel()
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                itemList
                addItemOverlay
            }
        }
        .fullScreenCover(isPresented: $vm.isAddItemShowing) {
            AddItemView(persistentStore: persistentStore, standard: true)
                .environment(\.managedObjectContext, persistentStore.context)
        }
        .fullScreenCover(isPresented: $vm.isQuickAddItemShowing) {
            AddItemView(persistentStore: persistentStore, shedIn: vm.selectedShed!)
                .environment(\.managedObjectContext, persistentStore.context)
        }
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
    }
}

extension AllItemsView {
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                Text("\(gsData.items.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(gsData.totalWeight(array: gsData.items))g")
            }
            HStack {
                Text("Invested:")
                Text("$\(gsData.totalCost(array: gsData.items))")
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
                ForEach(gsData.sectionByShed(itemArray: gsData.items)) { section in
                    Section {
                        ForEach(section.items, id: \.id) { item in
                            ItemRowView(item: item)
                                
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
                Text(section.title)
                    .font(.headline)
                
                Button {
                    let canCreate = self.persistentStore.fullVersionUnlocked ||
                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                    if canCreate {
                        let shed = section.shed
                        vm.selectedShed = shed
                        vm.isQuickAddItemShowing.toggle()
                    } else {
                        vm.showingUnlockView.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                }
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
                        vm.isAddItemShowing.toggle()
                    } else {
                        vm.showingUnlockView.toggle()
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
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
}










