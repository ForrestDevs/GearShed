//
//  BrandDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct BrandDetailView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager
    @StateObject private var viewModel: GearShedData
    @ObservedObject var brand: Brand
    
    @State private var isEditBrandShowing: Bool = false
    
    init(persistentStore: PersistentStore, brand: Brand) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.brand = brand
    }
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
                .padding(.top, 22.2)
                .padding(.bottom, 10)
            itemList
        }
        .navigationTitle(brand.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { self.isEditBrandShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditBrandShowing) {
            ModifyBrandView(brand: brand).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .onAppear {
            tabManager.hideTab = true
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                Text("\(brand.items.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(viewModel.totalWeight(array: brand.items))g")
            }
            HStack {
                Text("Invested:")
                Text("$\(viewModel.totalCost(array: brand.items))")
            }
            Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.vertical, 5)
        .offset(x: 45)
        .background(Color.theme.green)
        .padding(.top, 15)
    }
    
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.sectionByShed(itemArray: brand.items)) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowViewInBrand(item: item)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                } header: {
                    sectionHeader(section: section)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private func sectionHeader(section: SectionShedData) -> some View {
        return VStack (spacing: 0) {
            HStack {
                Text(section.title)
                    .font(.headline)
                Spacer()
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
}
