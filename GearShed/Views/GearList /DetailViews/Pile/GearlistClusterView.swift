//
//  GearlistClusterView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
import SwiftUI

struct GearlistClusterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @State private var confirmDeleteClusterAlert: ConfirmDeleteClusterAlert?
    
    @ObservedObject var gearlist: Gearlist
    
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .pile, gearlist: gearlist)
            ZStack {
                if gearlist.clusters.count == 0 {
                    EmptyViewText(emptyText: "Piles", buttonName: "Add Pile")
                } else {
                    gearlistClusterList
                }
                addClusterButtonOverlay
            }
        }
        .alert(item: $confirmDeleteClusterAlert) { cluster in cluster.alert() }
    }
    
    private var gearlistClusterList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(gearlist.clusters) { cluster in
                    Section {
                        listContent(cluster: cluster)
                    } header: {
                        listHeader(cluster: cluster)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private func listContent(cluster: Cluster) -> some View {
        ForEach(cluster.items) { item in
            ItemRowView_InCluster(cluster: cluster, item: item)
        }
    }
    
    private func listHeader(cluster: Cluster) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(cluster.name)
                    .font(.headline)
                Text("\(viewModel.clusterTotalWeight(cluster: cluster))g")
                Spacer()
                Menu {
                    Button {
                        detailManager.selectedCluster = cluster
                        withAnimation {
                            detailManager.secondaryTarget = .showAddItemsToCluster
                        }
                    } label: {
                        HStack {
                            Text("Add to Pile").textCase(.none)
                            Image(systemName: "plus")
                        }
                    }
                    Button {
                        detailManager.selectedCluster = cluster
                        withAnimation {
                            detailManager.secondaryTarget = .showModifyCluster
                        }
                    } label: {
                        HStack {
                            Text("Edit Pile Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    Button {
                        confirmDeleteClusterAlert = ConfirmDeleteClusterAlert (
                            persistentStore: persistentStore,
                            cluster: cluster,
                            destructiveCompletion: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    } label: {
                        HStack {
                            Text("Delete Pile").textCase(.none)
                            Image(systemName: "trash")
                        }
                        
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 15)
        }
    }
    
    private var addClusterButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddCluster
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Pile")
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


