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
                            .font(.headline)
                        Spacer()
                        Text("\(shed.items.count)")
                            .font(.headline)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .fullScreenCover (isPresented: $showDetail) {
            ShedDetailView(persistentStore: persistentStore, shed: shed)
        }
        .fullScreenCover (isPresented: $showEdit) {
            ModifyShedView(shed: shed)
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



