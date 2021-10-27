//
//  TripDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistDetailView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var gearVM: GearlistData
    @StateObject private var itemVM: GearShedData
    
    @ObservedObject var gearlist: Gearlist
    
    init(persistentStore: PersistentStore, gearlist: Gearlist) {
        let gearVM = GearlistData(persistentStore: persistentStore)
        _gearVM = StateObject(wrappedValue: gearVM)
        let itemVM = GearShedData(persistentStore: persistentStore)
        _itemVM = StateObject(wrappedValue: itemVM)
        self.gearlist = gearlist
    }
    
    var body: some View {
        VStack {
            ZStack {
                itemList
                editListOverlay
            }.padding(.bottom, 50)
            Rectangle()
               .opacity(0)
               .frame(height: 50)
        }
        .navigationTitle(gearlist.name)
    }
    
    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(itemVM.sectionByShed(itemArray: gearlist.items)) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowView(item: item)
                            .contextMenu {
                                listItemContextMenu (
                                    item: item,
                                    deletionTrigger: {
                                        Gearlist.removeItemFromList(item: item, gearlist: gearlist)
                                    }
                                )
                            }
                            .padding(.bottom, 5)
                    }
                } header: {
                    VStack (spacing: 0) {
                        HStack {
                            Text(section.title)
                                .font(.headline)
                            Spacer()
                        }
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var editListOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: AddMoreItemView(persistentStore: persistentStore, gearlist: gearlist)) {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("Item")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                    .frame(width: 55, height: 55)
                    .background(Color.theme.accent)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
                }
            }
        }
    }
    
}


// all editableData is packaged here. its initial values are set using
// a custom init.
//@State private var editableGearlistData: EditableGearlistData
// custom init to set up editable data
/*init(gearlist: Gearlist) {
    _editableGearlistData = State(initialValue: EditableGearlistData(gearlist: gearlist))
    self.gearlist = gearlist
}*/
