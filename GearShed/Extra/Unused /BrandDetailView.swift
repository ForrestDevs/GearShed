//
//  BrandDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//
/*
import SwiftUI

struct BrandDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @ObservedObject var brand: Brand
    
    @State private var isEditBrandShowing: Bool = false
    
    init(persistentStore: PersistentStore, brand: Brand) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.brand = brand
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                statBar
                itemList
            }
            .navigationBarTitle(brand.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { self.isEditBrandShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditBrandShowing) {
                ModifyBrandView(persistentStore: persistentStore, brand: brand).environment(\.managedObjectContext, persistentStore.context)
            }
        }
    }
}

extension BrandDetailView {
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
        .padding(.vertical, 5)
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.white)
        .background(Color.theme.green)
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
            .padding(.top, 10)
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
 */
