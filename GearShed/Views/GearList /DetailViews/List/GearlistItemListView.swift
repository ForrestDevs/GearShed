//
//  GearlistItemListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct GearlistItemListView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var showAddItem: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                itemList
                addItemButtonOverlay
            }
        }
        .fullScreenCover(isPresented: $showAddItem) {
            AddMoreItemView(persistentStore: persistentStore, gearlist: gearlist)
        }
    }
}

extension GearlistItemListView {
    
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.sectionByShed(itemArray: gearlist.items)) { section in
                    Section {
                        sectionItems(section: section)
                    } header: {
                        sectionHeader(section: section)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 75)
        }
    }
    
    private func sectionItems(section: SectionShedData) -> some View {
        ForEach(section.items) { item in
            ItemRowView_InGearlist(persistentStore: persistentStore, item: item, gearlist: gearlist)
        }
    }
    
    private func sectionHeader(section: SectionShedData) -> some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(section.title)
                    .font(.headline)
                Spacer()
                Text("\(viewModel.totalWeight(array: section.items))" + "g" ) 
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    private var addItemButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddItem.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Item")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20) {
            HStack {
                Text("Items:")
                Text("\(gearlist.items.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(viewModel.gearlistTotalWeight(gearlist: gearlist))g")
            }
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }

}
