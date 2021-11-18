//
//  ItemRowView-InContainer.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-11.
//

import SwiftUI

struct ItemRowView_InContainer: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject private var item: Item
    
    @ObservedObject private var gearlist: Gearlist
    
    @ObservedObject private var container: Container
    
    @State private var isPacked: Bool
    
    @State private var showDetail: Bool = false 
    
    init(item: Item, gearlist: Gearlist, container: Container) {
        self.item = item
        self.gearlist = gearlist
        self.container = container
        
        let initialState = item.gearlistContainerBool(gearlist: gearlist)?.isPacked
        
        _isPacked = State(initialValue: initialState!)
    }
    
    var body: some View {
        Button {
            isPacked.toggle()
            viewModel.toggleContainerBoolState(containerBool: item.gearlistContainerBool(gearlist: gearlist)!)
        } label: {
            HStack {
                itemPackStatus
                itemBody
            }
        }
        .contextMenu {
            deleteContextButton
            itemDetailContextButton
        }
        .sheet(isPresented: $showDetail) {
            ItemDetailView(item: item)
        }
    }
}

extension ItemRowView_InContainer {
    
    private var itemPackStatus: some View {
        ZStack {
            Image(systemName: "circle")
                .foregroundColor(Color.theme.green)
            if isPacked == true {
                Image(systemName: "bag.circle.fill")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
    
    private var itemBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(item.name)
                        .foregroundColor(Color.theme.green)
                    Text("|")
                    Text(item.brandName)
                        .foregroundColor(Color.theme.accent)
                }
                .font(.system(size: 16.2))
            }
            Spacer()
        }
        .padding(.horizontal, 2)
    }
    
    private var itemDetailContextButton: some View {
        Button {
            showDetail.toggle()
        } label: {
            Text("Item Detail")
        }
        
    }
    
    private var deleteContextButton: some View {
        Button {
            withAnimation {
                viewModel.removeItemFromContainer(item: item, container: container)
            }
        } label: {
            HStack {
                Text("Remove From Pack")
                Image(systemName: "trash")
            }
        }
        
    }
    
}

