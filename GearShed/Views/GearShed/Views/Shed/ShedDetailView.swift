//
//  ShedDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ShedDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @ObservedObject var shed: Shed
    
    @State private var isEditShedShowing: Bool = false
    
    init(persistentStore: PersistentStore, shed: Shed) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.shed = shed
    }

    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                statBar
                itemList
            }
            .navigationBarTitle(shed.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isEditShedShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditShedShowing) {
                ModifyShedView(persistentStore: persistentStore, shed: shed)
                    .environment(\.managedObjectContext, persistentStore.context)
            }
        }
        
    }
}

extension ShedDetailView {
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
        .padding(.vertical, 5)
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.white)
        .background(Color.theme.green)
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
            .padding(.top, 10)
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





