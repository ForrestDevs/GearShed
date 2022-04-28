//
//  GearShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//
import SwiftUI

struct GearShedView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @StateObject private var gsData: GearShedData
    @StateObject private var glData: GearlistData
    @StateObject private var viewModel = GearShedViewModel()
    @StateObject private var backupManager: BackupManager
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: viewModel)
        let data = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: data)
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
    }
    var body: some View {
        NavigationView {
            PagerTabView(tint: Color.theme.accent, selection: $viewModel.currentSelection) {
                Text("Shelf")
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
                //loadData
                shareButton
            }
        }
        .navigationViewStyle(.stack)
    }
}
extension GearShedView {
    //MARK: Nav Bar Buttons
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
                gsData.printPDF(pdfInt: viewModel.currentSelection)
            } label: {
                Text("PDF")
            }
        }
    }
    //MARK: Developer Data Functions
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

