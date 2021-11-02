//
//  BrandRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct BrandRowView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var persistentStore: PersistentStore
    
    @ObservedObject var brand: Brand
    
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
    @State private var showDetail: Bool = false
    @State private var showEdit: Bool = false

    var body: some View {
        ZStack {
            Color.clear
            VStack {
                Button {
                    showDetail.toggle()
                } label: {
                    HStack{
                        Text(brand.name)
                            .font(.headline)
                        Spacer()
                        Text("\(brand.itemCount)")
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
            BrandDetailView(persistentStore: persistentStore, brand: brand)
        }
        .fullScreenCover (isPresented: $showEdit) {
            ModifyBrandView(brand: brand)
        }
        .alert(item: $confirmDeleteBrandAlert) { brand in brand.alert() }
        
        
        .fullScreenCover(isPresented: $showDetail) {
            BrandDetailView(persistentStore: persistentStore,brand: brand)
        }
    }
    
}

extension BrandRowView {
    
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





