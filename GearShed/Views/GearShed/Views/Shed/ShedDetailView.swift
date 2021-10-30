//
//  ShedDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ShedDetailView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager
    
    @StateObject private var viewModel: GearShedData
    
    @ObservedObject var shed: Shed
    
    @State private var isEditShedShowing: Bool = false
    
    init(persistentStore: PersistentStore, shed: Shed) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.shed = shed
    }

    var body: some View {
        VStack(spacing:0) {
            statBar
                .padding(.top, 22.2)
                .padding(.bottom, 10)
            itemList
        }
        .navigationTitle(shed.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { isEditShedShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditShedShowing) {
            ModifyShedView(shed: shed).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .onAppear {
            tabManager.hideTab = true
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                Text("\(shed.items.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(viewModel.totalWeight(array: shed.items))g")
            }
            HStack {
                Text("Invested:")
                Text("$\(viewModel.totalCost(array: shed.items))")
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
            ForEach(viewModel.sectionByBrand(itemArray: shed.items)) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowViewInShed(item: item)
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
    
    private func sectionHeader(section: SectionBrandData) -> some View {
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





