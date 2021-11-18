//
//  ShedItemsRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//
/*
import SwiftUI

struct ShedItemsRowView: View {
    
    @Environment (\.presentationMode) var presentationMode

    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var gsData: GearShedData
    
    @EnvironmentObject private var viewModel: ShedItemsViewModel

    @ObservedObject var shed: Shed
    
    @State private var showEdit: Bool = false
    
    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            shedHeader
                .padding(.horizontal)
            shedItems
                .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $viewModel.isQuickAddItemShowing) {
            AddItemView(persistentStore: persistentStore, shedIn: viewModel.selectedShed!)
                .environment(\.managedObjectContext, persistentStore.context)
        }
        .fullScreenCover(isPresented: $showEdit) {
            ModifyShedView(persistentStore: persistentStore, shed: shed)
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
        .alert(item: $confirmDeleteShedAlert) { shed in shed.alert() }
    }
    
}

extension ShedItemsRowView {
    
    private var shedHeader: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(shed.name)
                    .font(.headline)
                quickAddItemButton
                Spacer()
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
    
    private var quickAddItemButton: some View {
        Button {
            let canCreate = self.persistentStore.fullVersionUnlocked ||
                self.persistentStore.count(for: Item.fetchRequest()) < 3
            if canCreate {
                viewModel.selectedShed = shed
                viewModel.isQuickAddItemShowing.toggle()
            } else {
                viewModel.showingUnlockView.toggle()
            }
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private var shedItems: some View {
        List {
            ForEach(shed.items) { item in
                ItemRowView(item: item)
            }
        }
        /*LazyVStack {
            ForEach(shed.items) { item in
                ItemRowView(item: item)
            }
        }
        .padding(.top, 7)*/
    }
    
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
*/
