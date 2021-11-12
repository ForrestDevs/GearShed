//
//  ShedRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ShedRowView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var persistentStore: PersistentStore
    
    @ObservedObject var shed: Shed
    
    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
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
                        Text(shed.name)
                        
                        Spacer()
                        
                        Text("\(shed.items.count)")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2.5)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .fullScreenCover (isPresented: $showDetail) {
            ShedDetailView(persistentStore: persistentStore, shed: shed)
        }
        .fullScreenCover (isPresented: $showEdit) {
            ModifyShedView(persistentStore: persistentStore ,shed: shed)
                //.environmentObject(persistentStore)
        }
        .alert(item: $confirmDeleteShedAlert) { shed in shed.alert() }
    }
}

extension ShedRowView {
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            HStack {
                Text("Edit Shed")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteShedAlert = ConfirmDeleteShedAlert (
                persistentStore: persistentStore,
                shed: shed,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Shed")
                Image(systemName: "trash")
            }
        }
    }
    
}



