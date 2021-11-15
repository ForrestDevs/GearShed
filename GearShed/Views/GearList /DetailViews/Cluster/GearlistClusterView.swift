//
//  GearlistClusterView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct GearlistClusterView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var showAddCluster: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                gearlistClusterList
                addClusterButtonOverlay
            }
        }
        .fullScreenCover(isPresented: $showAddCluster) {
            AddClusterView(persistentStore: persistentStore, gearlist: gearlist)
        }
    }
    
}

extension GearlistClusterView {
    
    private var gearlistClusterList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(gearlist.clusters) { listGroup in
                    ClusterRowView(cluster: listGroup)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 75)
        }
    }
    
    private var addClusterButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddCluster.toggle()
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
        HStack (spacing: 20){
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