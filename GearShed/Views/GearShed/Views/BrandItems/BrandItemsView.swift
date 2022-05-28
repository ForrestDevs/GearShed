//
//  BrandItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct BrandItemsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var gsData: GearShedData
    @EnvironmentObject private var gsvm: GearShedViewModel
    @StateObject private var vm = BrandItemsViewModel()
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .brand)
                if gsData.brands.count == 0 {
                    EmptyViewText(text: "You have no brands, to get started - press the 'Add Brand' button bellow.")
                } else {
                    listView
                }
            }
            // Invisible Rects for seperate alerts
            Rectangle()
                .opacity(0)
                .alert(item: $vm.confirmDeleteBrandAlert) { brand in brand.alert() }
            Rectangle()
                .opacity(0)
                .alert(item: $gsvm.confirmDeleteItemAlert) { item in item.alert() }
            addBrandButton
        }
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach (gsData.brands) { brand in
                    Section {
                        sectionContent(brand: brand)
                    } header: {
                        sectionHeader(brand: brand)
                    }
                }
            }
        }
    }
    
    private func sectionContent(brand: Brand) -> some View {
        ForEach (brand.items) { item in
            if gsData.showAll {
                VStack {
                    ItemRowView(item: item)
                        .padding(.leading, 15)
                }
            }
        }
    }
    
    private func sectionHeader(brand: Brand) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(brand.name).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
                Menu {
                    Button {
                        let canCreate = self.persistentStore.fullVersionUnlocked ||
                            self.persistentStore.count(for: Item.fetchRequest()) < 3
                        if canCreate {
                            detailManager.selectedBrand = brand
                            withAnimation {
                                detailManager.target = .showAddItemFromBrand
                            }
                        } else {
                            vm.showingUnlockView.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Add Gear to Brand").textCase(.none)
                            Image(systemName: "plus")
                        }
                    }
                    Button {
                        detailManager.selectedBrand = brand
                        withAnimation {
                            detailManager.target = .showModifyBrand
                        }
                    } label: {
                        HStack {
                            Text("Edit Brand Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    Button {
                        vm.confirmDeleteBrandAlert = ConfirmDeleteBrandAlert (
                            persistentStore: persistentStore,
                            brand: brand,
                            destructiveCompletion: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    } label: {
                        HStack {
                            Text("Delete Brand").textCase(.none)
                            Image(systemName: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 15)
        }
    }
    
    private var addBrandButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.tertiaryTarget = .noView
                    withAnimation {
                        detailManager.tertiaryTarget = .showAddBrand
                    }
                } label: {
                    VStack {
                        Text("Add")
                        Text("Brand")
                    }
                    .foregroundColor(Color.theme.background)
                    .font(.system(size: 12, weight: .regular))
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 5)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
        .padding(.bottom, 70)
    }
}
