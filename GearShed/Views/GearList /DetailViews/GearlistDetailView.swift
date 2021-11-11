//
//  TripDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    //let persistentStore: PersistentStore
    
    //@StateObject private var viewModel: GearlistData
    
    @ObservedObject private var gearlist: Gearlist
    
    @State private var currentScreen: Int = 0
    @State private var isEditMode: Bool = true
    @State private var addCluster: Bool = false
            
    init(gearlist: Gearlist) {
        
        self.gearlist = gearlist
        
    }
    
    var body: some View {
        NavigationView {
            PagerTabView(tint: Color.theme.accent, selection: $currentScreen) {
                Text("List")
                    .pageLabel()
                Text("Cluster")
                    .pageLabel()
                Text("Container")
                    .pageLabel()
            } content: {
                GearlistItemListView(gearlist: gearlist)
                    .pageView()
                GearlistClusterView(gearlist: gearlist)
                    .pageView()
                GearlistContainerView(gearlist: gearlist)
                    .pageView()
            }
            .padding(.top, 10)
            .navigationBarTitle(gearlist.name, displayMode: .inline)
            .toolbar {
                backButtonToolBarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
}

extension GearlistDetailView {
    
    private var backButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showGearlistDetail = false
                }
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    
    private var addItemOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                
                } label: {
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
                    .padding(.bottom, 20)
                    .padding(.trailing, 15)
                    .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
                }
            }
        }
    }

}

/*private var listModeToolbarContent: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
        Button {
            isEditMode.toggle()
        } label: {
            if isEditMode {
                Text("Edit Mode")
            } else {
                Text("Packing Mode")
            }
        }
    }
}*/

/*private var listGroupList: some View {
    ScrollView(.vertical, showsIndicators: false) {
        if gearlist.listGroups.count == 0 {
            Text("You have No List Groups Click To Add One Below")
        } else {
            ForEach(gearlist.listGroups) { listGroup in
                ClusterRowView(persistentStore: persistentStore, listGroup: listGroup, gearlist: gearlist)
            }
        }
    }
}*/

/*private var packingModeList: some View {
    VStack{
        ForEach(viewModel.gearlistPackingGroups(gearlist: gearlist)) { packingGroup in
            PackingGroupRowView(persistentStore: persistentStore, packingGroup: packingGroup)
        }
        Spacer()
    }
    .onDisappear{
        persistentStore.saveContext()
    }
}*/

/*private var listGroupMenuList: some View {
    ForEach(viewModel.listgroups) { listGroup in
        Button {
            
            //editableData.packingGroup = packingGroup
            //viewModel.updateItemPackingGroup(using: editableData)
        } label: {
            Text(listGroup.name)
                .font(.subheadline)
        }
    }
}*/

/*private var addNewClusterButton: some View {
    Button {
        addCluster.toggle()
    } label: {
        Text("Add New List Group")
            .font(.subheadline)
    }
}*/

/*private var itemList: some View {
    ScrollView(.vertical, showsIndicators: false) {
        ForEach(itemVM.sectionByShed(itemArray: gearlist.items)) { section in
            Section {
                ForEach(section.items) { item in
                    ItemRowView(item: item)
                        .contextMenu {
                            listItemContextMenu (
                                item: item,
                                deletionTrigger: {
                                    //Gearlist.removeItemFromList(item: item, gearlist: gearlist)
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
        .padding(.top, 10)
    }
}*/
/*VStack {
    Text(packingGroup.name)
    Rectangle()
        .frame(maxWidth: .infinity)
        .frame(height: 1)
    ForEach(packingGroup.items) { item in
        Text(item.name)
    }
}*/
