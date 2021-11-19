//
//  BrandItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//

import SwiftUI

struct BrandItemsView: View {
    
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var detailManager: DetailViewManager

    @EnvironmentObject private var gsData: GearShedData

    @StateObject private var vm = BrandItemsViewModel()
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .brand)
                if gsData.brands.count == 0 {
                    EmptyViewText(emptyText: "Brands", buttonName: "Add Brand")
                } else {
                    listContent
                }
            }
            ExpandableButton(type: .brand)
                .environmentObject(detailManager)
        }
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
        .alert(item: $vm.confirmDeleteBrandAlert) { brand in brand.alert() }
    }
    
}

extension BrandItemsView {
    
    private var listContent: some View {
        List {
            ForEach(gsData.brands) { brand in
                Section {
                    if gsData.showAll {
                        ForEach(brand.items) { item in
                            ItemRowView(item: item)
                        }
                    }
                } header: {
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
                                        detailManager.showAddItemFromBrand = true
                                    }
                                } else {
                                    vm.showingUnlockView.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("Add To Brand").textCase(.none)
                                    Image(systemName: "plus")
                                }
                            }
                            Button {
                                detailManager.selectedBrand = brand
                                withAnimation {
                                    detailManager.showModifyBrand = true
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
                }
            }
        }
        .listStyle(.plain)
    }
}

