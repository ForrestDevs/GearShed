//
//  GearShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearShedView: View {
    static let tag: String? = "GearShed"
    
    @EnvironmentObject private var detailManager: DetailViewManager
        
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var gsData: GearShedData
    @StateObject private var viewModel = GearShedViewModel()
    
    @State private var showFilterOptions: Bool = false
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            content
        }
        .navigationBarTitle(navTitle(), displayMode: .inline)
        .toolbar {
            filterButton
            shareButton
        }
        .fullScreenCover(isPresented: $viewModel.showPDFScreen) {
            NavigationView {
                PDFExportView(persistentStore: persistentStore)
            }
        }
        .onDisappear {
            persistentStore.saveContext()
        }
    }
}

extension GearShedView {
    
    private func navTitle() -> String {
        var title: String = ""
        
        if viewModel.viewFilter == .shed {
            title = "Gear Shed"
        }
        if viewModel.viewFilter == .brand {
            title = "Brand"

        }
        if viewModel.viewFilter == .fav {
            title = "Favourite"

        }
        if viewModel.viewFilter == .regret {
            title = "Regret"
        }
        if viewModel.viewFilter == .wish {
            title = "Wishlist"
        }
        
        return title
    }
    
    private var shareButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.showPDFScreen.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
    
    private var filterButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Menu {
                Text("Filter by:")
                    .foregroundColor(Color.theme.accent)
                Divider()
                VStack {
                    Button {
                        viewModel.viewFilter = .shed
                        showFilterOptions.toggle()
                    } label: {
                        HStack {
                            Text("Shed").frame(alignment: .center)
                            if viewModel.viewFilter == .shed {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                    
                    Button {
                        viewModel.viewFilter = .brand
                        showFilterOptions.toggle()
                    } label: {
                        HStack {
                            Text("Brand").frame(alignment: .center)
                            if viewModel.viewFilter == .brand {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Button {
                        viewModel.viewFilter = .fav
                        showFilterOptions.toggle()
                    } label: {
                        HStack {
                            Text("Favourite").frame(alignment: .center)
                            if viewModel.viewFilter == .fav {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                    
                    Button {
                        viewModel.viewFilter = .regret
                        showFilterOptions.toggle()
                    } label: {
                        HStack {
                            Text("Regret").frame(alignment: .center)
                            if viewModel.viewFilter == .regret {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                    
                    Button {
                        viewModel.viewFilter = .wish
                        showFilterOptions.toggle()
                    } label: {
                        HStack {
                            Text("Wish").frame(alignment: .center)
                            if viewModel.viewFilter == .wish {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                }
            } label: {
                Image(systemName: "text.magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 5)
                }
            
        }
    }
    
    private var statBar: some View {
        VStack (spacing: 0) {
            HStack (spacing: 20) {
                if viewModel.viewFilter == .shed {
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
                } else if viewModel.viewFilter == .brand {
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
                } else if viewModel.viewFilter == .fav {
                    HStack {
                        Text("Items:")
                        Text("\(gsData.favItems.count)")
                    }
                    HStack {
                        Text("Weight:")
                        Text("\(gsData.totalWeight(array: gsData.favItems))g")
                    }
                    HStack {
                        Text("Invested:")
                        Text("$\(gsData.totalCost(array: gsData.favItems))")
                    }
                } else if viewModel.viewFilter == .regret {
                    HStack {
                        Text("Items:")
                        Text("\(gsData.regretItems.count)")
                    }
                    HStack {
                        Text("Invested:")
                        Text("$\(gsData.totalCost(array: gsData.regretItems))")
                    }
                } else if viewModel.viewFilter == .wish {
                    HStack {
                        Text("Items:")
                        Text("\(gsData.wishListItems.count)")
                    }
                    HStack {
                        Text("Cost:")
                        Text("$\(gsData.totalCost(array: gsData.wishListItems))")
                    }
                }
                Spacer()
            }
            .font(.custom("HelveticaNeue", size: 14))
            .foregroundColor(Color.white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.theme.green)
        }
    }

    private var content: some View {
        VStack {
            if viewModel.viewFilter == .shed {
                ShedItemsView()
                    .environmentObject(gsData)
                    .environmentObject(detailManager)
            } else if viewModel.viewFilter == .brand {
                BrandItemsView()
                    .environmentObject(gsData)
            } else if viewModel.viewFilter == .fav {
                FavsView()
                    .environmentObject(gsData)
            } else if viewModel.viewFilter == .regret {
                RegretsView()
                    .environmentObject(gsData)
            } else if viewModel.viewFilter == .wish {
                WishesView()
                    .environmentObject(gsData)
            }
        }
    }
}
