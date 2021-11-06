//
//  ItemRowViewInShed.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//

import SwiftUI

struct ItemRowViewInShed: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @ObservedObject var item: Item
    
    @State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    @State private var showDetail: Bool = false
    @State private var showEdit: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
            HStack (alignment: .firstTextBaseline , spacing: 15) {
                favouriteButton
                Button {
                    showDetail.toggle()
                } label: {
                    itemBody
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .fullScreenCover (isPresented: $showDetail) {
            ItemDetailView(item: item)
        }
        .fullScreenCover (isPresented: $showEdit) {
            ModifyItemView(persistentStore: persistentStore, editableItem: item)
                .environment(\.managedObjectContext, persistentStore.context)
        }
        .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
    }
}

extension ItemRowViewInShed {
    
    private var favouriteButton: some View {
        Image(systemName: item.isFavourite ? "heart.fill" : "heart")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            .onTapGesture {
                item.toggleRegretStatus()
                item.toggleFavouriteStatus()
            }
    }
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            HStack {
                Text("Edit Item")
                Image(systemName: "square.and.pencil")
            }
            
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteItemAlert = ConfirmDeleteItemAlert (
                persistentStore: persistentStore,
                item: item,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Item")
                Image(systemName: "trash")
            }
        }
    }
    
    private var itemBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 0) {
                Text(item.name)
                    .foregroundColor(Color.theme.accent)
                HStack {
                    Text("\(item.weight)g")
                    Text(item.detail)
                        .frame(maxHeight: 35)
                }
                .font(.caption)
                .foregroundColor(Color.theme.green)
            }
            Spacer()
        }
    }
    
}
