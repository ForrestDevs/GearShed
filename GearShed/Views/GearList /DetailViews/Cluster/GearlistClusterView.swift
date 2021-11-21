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
    
}

extension GearlistClusterView {
    
    private var gearlistClusterList: some View {
        List {
            ForEach(gearlist.clusters) { cluster in
                Section {
                    ForEach(cluster.items) { item in
                        ItemRowView_InCluster(cluster: cluster, item: item)
                    }
                } header: {
                    HStack {
                        Text(cluster.name)
                            .font(.headline)
                        Text("\(viewModel.clusterTotalWeight(cluster: cluster))g")
                        Spacer()
                        Menu {
                            Button {
                                detailManager.selectedCluster = cluster
                                withAnimation {
                                    detailManager.showAddItemsToCluster = true
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
                                    detailManager.showModifyCluster = true
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
                }
                
            }
        }
        .listStyle(.plain)
    }
    
    private var addClusterButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.showAddCluster = true
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
    
    private var statBar: some View {
        HStack (spacing: 20) {
            Text (
                "Items: " +
                "\(viewModel.gearlistClusterTotalItems(gearlist: gearlist))"
            )
            
            Text (
                "Weight: " +
                "\(viewModel.gearlistClusterTotalWeight(gearlist: gearlist))" +
                "g"
            )
            
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
