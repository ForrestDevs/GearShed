//
//  GearlistRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistRowView: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject var viewModel: GearlistData
    
    @EnvironmentObject var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var gearlist: Gearlist
    
    @State private var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    @State private var showDetail: Bool = false
    @State private var showEdit: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
            VStack {
                Button {
                    withAnimation {
                        detailManager.content = AnyView (
                            GearlistDetailView (
                                //persistentStore: persistentStore,
                                gearlist: gearlist
                            )
                            .environmentObject(viewModel)
                            .environmentObject(persistentStore)
                            .environmentObject(detailManager)
                        )
                        
                        detailManager.showGearlistDetail = true
                        //showDetail.toggle()
                    }
                } label: {
                    HStack {
                        Text(gearlist.name)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        
        /*.fullScreenCover(isPresented: $showDetail) {
            GearlistDetailView(persistentStore: persistentStore, gearlist: gearlist)
        }*/
        .fullScreenCover(isPresented: $showEdit) {
            ModifyListView(persistentStore: persistentStore, gearlist: gearlist)
        }
        .alert(item: $confirmDeleteGearlistAlert) { gearlist in gearlist.alert() }
    }
}

extension GearlistRowView {
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            HStack {
                Text("Edit List")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteGearlistAlert = ConfirmDeleteGearlistAlert (
                persistentStore: persistentStore,
                gearlist: gearlist,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete List")
                Image(systemName: "trash")
            }
        }
    }
}




