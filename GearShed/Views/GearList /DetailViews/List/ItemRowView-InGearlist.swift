//
//  ItemRowView-InGearlist.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ItemRowView_InGearlist: View {
    @Environment (\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var viewModel: GearlistData
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @ObservedObject private var gearlist: Gearlist
    @ObservedObject private var item: Item
    
    //@State private var confirmRemoveItemAlert: ConfirmRemoveItemFromListAlert?
    //@State private var showAddNewCluster: Bool = false
    //@State private var showAddNewContainer: Bool = false
    
    @State var itemCluster: Cluster?
    @State var previousItemCluster: Cluster?
    
    @State var itemContainer: Container?
    @State var previousItemContainer: Container?
    
    init(persistentStore: PersistentStore, item: Item, gearlist: Gearlist) {
        self.gearlist = gearlist
        self.item = item
        
        let initialCluster = item.gearlistCluster(gearlist: gearlist)
        _itemCluster = State(initialValue: initialCluster)
        _previousItemCluster = State(initialValue: initialCluster)
        
        let initialContainer = item.gearlistContainer(gearlist: gearlist)
        _itemContainer = State(initialValue: initialContainer)
        _previousItemContainer = State(initialValue: initialContainer)
    }
    
    var body: some View {
        itemBody
        .contextMenu {
            deleteContextButton
        }
        /*.fullScreenCover(isPresented: $showAddNewCluster) {
            AddClusterView(persistentStore: persistentStore, gearlist: gearlist) { cluster in
                itemCluster = cluster
                viewModel.updateItemCluster(newCluster: itemCluster, oldCluster: previousItemCluster, item: item)
                previousItemCluster = itemCluster
            }
        }
        .fullScreenCover(isPresented: $showAddNewContainer) {
            AddContainerView(persistentStore: persistentStore, gearlist: gearlist) { container in
                itemContainer = container
                viewModel.updateItemContainer(newContainer: itemContainer, oldContainer: previousItemContainer, item: item, gearlist: gearlist)
                previousItemContainer = itemContainer
            }
        }*/
        //.alert(item: $confirmRemoveItemAlert) { item in item.alert() }
    }
}

extension ItemRowView_InGearlist {
    
    private var itemBody: some View {
        HStack {
            Rectangle()
                .opacity(0)
                .frame(width: 5, height: 10)
            VStack (alignment: .leading, spacing: 2) {
                HStack {
                    Text(item.name)
                        .foregroundColor(Color.theme.green)
                    Text("|")
                    Text(item.brandName)
                        .foregroundColor(Color.theme.accent)
                }
                HStack (spacing: 20){
                    Text(item.weight + "g")
                        .font(.system(size: 13))
                        .foregroundColor(Color.theme.accent)
                    HStack {
                        clusterMenu
                        containerMenu
                    }
                }
                .padding(.horizontal, 10)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
    
    // MARK: Context Menus
    private var deleteContextButton: some View {
        Button {
            withAnimation {
                viewModel.removeItemFromGearlist(item: item, gearlist: gearlist)
            }
        } label: {
            HStack {
                Text("Remove From List")
                Image(systemName: "trash")
            }
        }
    }
    
    // MARK: ContainerMenu
    private var containerMenu: some View {
        Menu {
            containerList
        } label: {
            containerMenuLabel
        }
    }
    
    private var containerList: some View {
        ForEach(viewModel.gearlistContainers(gearlist: gearlist)) { container in
            Button {
                itemContainer = container
                viewModel.updateItemContainer(newContainer: itemContainer, oldContainer: previousItemContainer, item: item, gearlist: gearlist)
                previousItemContainer = itemContainer
            } label: {
                HStack {
                    Text(container.name)
                        .font(.subheadline)
                    if item.containers.contains(container) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.theme.green)
                    }
                }
            }
        }
    }
    
    private var containerMenuLabel: some View {
        if ((item.gearlistContainer(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pack: " + (item.gearlistContainer(gearlist: gearlist)!.name))
                    .font(.system(size: 13))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        } else {
            return AnyView (
                HStack (spacing: 0){
                    Text ("Pack: ")
                        .font(.system(size: 13))
                    Text("Select")
                        .foregroundColor(Color.red)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        }
    }
    
    /*private var addNewContainer: some View {
        Button {
            detailManager.content = AnyView (
                AddContainerView(persistentStore: persistentStore, gearlist: gearlist) { container in
                    itemContainer = container
                    viewModel.updateItemContainer(newContainer: itemContainer, oldContainer: previousItemContainer, item: item, gearlist: gearlist)
                    previousItemContainer = itemContainer
                }.environmentObject(detailManager)
            )
            withAnimation {
                detailManager.showContent = true
            }
        } label: {
            Text("Add")
            .font(.subheadline)
        }
    }
    
    private var containerMenuEdit: some View {
        Button {
            
        } label: {
            Text("Edit")
        }
    }
    
    private var containerMenuDelete: some View {
        Button {
            
        } label: {
            Text("Delete")
        }
    }*/
    
    
    
    // MARK: ClusterMenu
    private var clusterMenu: some View {
        Menu {
            clusterList
        } label: {
            clusterMenuLabel
        }
    }
    
    private var clusterList: some View {
        ForEach(viewModel.gearlistClusters(gearlist: gearlist)) { cluster in
            Button {
                itemCluster = cluster
                viewModel.updateItemCluster(newCluster: itemCluster, oldCluster: previousItemCluster, item: item)
                previousItemCluster = itemCluster
            } label: {
                HStack {
                    Text(cluster.name)
                        .font(.subheadline)
                    if item.clusters.contains(cluster) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.theme.green)
                    }
                }
            }
        }
    }
    
    private var clusterMenuLabel: some View {
        if ((item.gearlistCluster(gearlist: gearlist)?.name) != nil) {
            return AnyView (
                Text ("Pile: " + (item.gearlistCluster(gearlist: gearlist)!.name))
                    .font(.system(size: 13))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        } else {
            return AnyView (
                HStack (spacing: 0) {
                    Text("Pile: ")
                        .font(.system(size: 13))
                    Text ("Select")
                        .foregroundColor(Color.red)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            )
        }
    }
    
    private var addNewCluster: some View {
        Button {
            detailManager.content = AnyView (
                AddClusterView(persistentStore: persistentStore, gearlist: gearlist) { cluster in
                    itemCluster = cluster
                    viewModel.updateItemCluster(newCluster: itemCluster, oldCluster: previousItemCluster, item: item)
                    previousItemCluster = itemCluster
                }.environmentObject(detailManager)
            )
            withAnimation {
                detailManager.showContent = true
            }
        } label: {
            Text("Add New Pile")
            .font(.subheadline)
        }
    }
}

