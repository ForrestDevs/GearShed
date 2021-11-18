//
//  BrandItemsRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//

import SwiftUI

struct BrandItemsRowView: View {
    
    @Environment (\.presentationMode) var presentationMode

    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var gsData: GearShedData
    
    @EnvironmentObject private var viewModel: BrandItemsViewModel

    @ObservedObject var brand: Brand
    
    @State private var showEdit: Bool = false
    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            brandHeader
                .padding(.horizontal)
            brandItems
                .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $viewModel.isQuickAddItemShowing) {
            AddItemView(persistentStore: persistentStore, brandIn: viewModel.selectedBrand!)
                .environment(\.managedObjectContext, persistentStore.context)
        }
        .fullScreenCover(isPresented: $showEdit) {
            ModifyBrandView(persistentStore: persistentStore, brand: brand)
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
        .alert(item: $confirmDeleteBrandAlert) { brand in brand.alert() }
    }
    
}

extension BrandItemsRowView {
    
    private var brandHeader: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(brand.name)
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
                viewModel.selectedBrand = brand
                viewModel.isQuickAddItemShowing.toggle()
            } else {
                viewModel.showingUnlockView.toggle()
            }
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private var brandItems: some View {
        LazyVStack {
            ForEach(brand.items) { item in
                ItemRowView(item: item)
            }
        }
        .padding(.top, 7)
    }
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            HStack {
                Text("Edit Brand")
                Image(systemName: "square.and.pencil")
            }
            
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteBrandAlert = ConfirmDeleteBrandAlert (
                persistentStore: persistentStore,
                brand: brand,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Brand")
                Image(systemName: "trash")
            }
        }
    }
    
}

