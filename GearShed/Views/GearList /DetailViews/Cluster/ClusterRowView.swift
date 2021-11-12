//
//  ClusterRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct ClusterRowView: View {
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var cluster: Cluster
    
    @State private var showEdit: Bool = false
    
    @State private var confirmDeleteClusterAlert: ConfirmDeleteClusterAlert?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            clusterHeader
            clusterItems
        }
        .fullScreenCover(isPresented: $showEdit) {
            EditClusterView(persistentStore: persistentStore, cluster: cluster)
        }
        .alert(item: $confirmDeleteClusterAlert) { cluster in cluster.alert() }
    }
    
}

extension ClusterRowView {
    
    private var clusterHeader: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(cluster.name)
                    .font(.headline)
                Spacer()
                Text("\(viewModel.clusterTotalWeight(cluster: cluster))g")
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
    }
    
    private var clusterItems: some View {
        ForEach(cluster.items) { item in
            ItemRowView_InCluster(cluster: cluster, item: item)
        }
        .padding(.horizontal)
        .padding(.top, 7)
    }
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            Text("Edit Cluster")
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteClusterAlert = ConfirmDeleteClusterAlert (
                persistentStore: persistentStore,
                cluster: cluster,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            Text("Delete Cluster")
        }
    }
    
}

