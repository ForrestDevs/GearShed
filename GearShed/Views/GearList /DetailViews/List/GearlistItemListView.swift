//
//  GearlistItemListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
import SwiftUI

struct GearlistItemListView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var gearlist: Gearlist
        
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .list, gearlist: gearlist)
            ZStack {
                if gearlist.items.count == 0 {
                    EmptyViewText(emptyText: "Items in this List", buttonName: "Revise List")
                } else {
                    itemList
                }
                
                addItemButtonOverlay
            }
        }
    }
    
    private var itemList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.sectionByShed(itemArray: gearlist.items)) { section in
                    Section {
                        sectionItems(section: section)
                    } header: {
                        sectionHeader(section: section)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private func sectionItems(section: SectionShedData) -> some View {
        ForEach(section.items) { item in
            ItemRowView_InGearlist(persistentStore: persistentStore, item: item, gearlist: gearlist)
        }
    }
    
    private func sectionHeader(section: SectionShedData) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(section.title)
                    .font(.headline)
                Spacer()
                Text("\(viewModel.totalWeight(array: section.items))" + "g" )
            }
            .padding(.horizontal, 15)
        }
    }
    
    private var addItemButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    //detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddItemsToGearlist
                    }
                }
                label: {
                    VStack{
                        Text("Select")
                        Text("Gear")
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
}
