//
//  GearShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
import SwiftUI

struct GearShedView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    @StateObject private var gsData: GearShedData
    @StateObject private var viewModel = GearShedViewModel()
    @StateObject private var backupManager: BackupManager
    @State private var currentSelection: Int = 0
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: viewModel)
        
        let data = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: data)
    }
    
    var body: some View {
        NavigationView {
            PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
                Text("Shed")
                    .formatPageHeaderTitle()
                    .pageLabel()
                Text("Brand")
                    .formatPageHeaderTitle()
                    .pageLabel()
                
                HStack(spacing: 1) {
                    Text("Wish")
                        .formatPageHeaderTitle()
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.yellow)
                        .offset(y: -6)
                }
                .pageLabel()
                
                HStack(spacing: 1) {
                    Text("Fav")
                        .formatPageHeaderTitle()
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.red)
                        .offset(y: -6)
                }
                .pageLabel()
                HStack(spacing: 1) {
                    Text("Regret")
                        .formatPageHeaderTitle()
                    Image(systemName: "hand.thumbsdown.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.theme.regretColor)
                        .offset(y: -6)
                }
                .pageLabel()
                
            } content: {
                ShedItemsView()
                    .environmentObject(gsData)
                    .environmentObject(viewModel)
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                BrandItemsView()
                    .environmentObject(gsData)
                    .environmentObject(viewModel)

                    .pageView(ignoresSafeArea: true, edges: .bottom)
                WishesView()
                    .environmentObject(gsData)
                    .environmentObject(viewModel)

                    .pageView(ignoresSafeArea: true, edges: .bottom)
                FavsView()
                    .environmentObject(gsData)
                    .environmentObject(viewModel)

                    .pageView(ignoresSafeArea: true, edges: .bottom)
                RegretsView()
                    .environmentObject(gsData)
                    .environmentObject(viewModel)

                    .pageView(ignoresSafeArea: true, edges: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                listExpandingButton
                viewTitle
                loadData
                shareButton
            }
            .fullScreenCover(isPresented: $viewModel.showPDFScreen) {
                NavigationView {
                    PDFExportView(persistentStore: persistentStore)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
extension GearShedView {
    
    private var listExpandingButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    gsData.showAll.toggle()
                }
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(gsData.showAll ? 180 : 0))
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Gear Shed")
                .formatGreen()
        }
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
    
    private var loadData: some ToolbarContent {
        ToolbarItem (placement: .navigationBarLeading) {
            Button {
                backupManager.insertISBFromBackUp(url: Bundle.main.url(forResource: "backup", withExtension: "json")!)
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    private func makeData() {
        for x in 1...20 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                let newShed = Shed(context: persistentStore.context)
                newShed.id = UUID()
                newShed.name = "Shed \(x)"
                
                let newBrand = Brand(context: persistentStore.context)
                newBrand.id = UUID()
                newBrand.name = "Brand \(x)"
                
                for i in 1...5 {
                    let newItem = Item(context: persistentStore.context)
                    newItem.id = UUID()
                    newItem.name = "Item \(i) in \(x)"
                    newItem.detail = "Test \(i) in \(x)"
                    newItem.price = "\(i)"
                    newItem.weight = "\(i)"
                    newItem.shed = newShed
                    newItem.brand = newBrand
                }
            })
        }
        persistentStore.saveContext()
    }
}

/*VStack (alignment: .center, spacing: 0.5)  {
    Image(systemName: "chevron.up")
        .foregroundColor(gsData.showAll ? Color.theme.green : Color.theme.accent)
    Image(systemName: "chevron.down")
        .foregroundColor(gsData.showAll ? Color.theme.accent : Color.theme.green)
}*/
/*private var filterButton: some ToolbarContent {
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

// Stress Test

 
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
 
 */
