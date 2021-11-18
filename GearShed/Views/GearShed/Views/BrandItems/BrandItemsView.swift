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
    
    @State private var showEdit: Bool = false
    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(gsData.brands) { brand in
                        Section {
                            ForEach(brand.items) { item in
                                ItemRowView(item: item)
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
                                        confirmDeleteBrandAlert = ConfirmDeleteBrandAlert (
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
            ExpandableButton()
                .environmentObject(detailManager)
        }
        
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
        .alert(item: $confirmDeleteBrandAlert) { brand in brand.alert() }
        
        
    }
    
}

