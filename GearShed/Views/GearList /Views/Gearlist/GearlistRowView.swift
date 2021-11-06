//
//  GearlistRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistRowView: View {
    @Environment(\.presentationMode) var presentationMode

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
                    showDetail.toggle()
                } label: {
                    HStack {
                        Text(gearlist.name)
                        Spacer()
                        //Text("\(gearlist.listGroup.count)")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .alert(item: $confirmDeleteGearlistAlert) { gearlist in gearlist.alert() }
        .fullScreenCover(isPresented: $showDetail) {
            GearlistDetailView(persistentStore: persistentStore, gearlist: gearlist)
        }
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


