//
//  ItemRowView-InContainer.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-11.
//
import SwiftUI

struct ItemRowView_InContainer: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var detailManager: DetailViewManager
        
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
            itemBody
        }
        .contextMenu {
            deleteContextButton
            itemDetailContextButton
        }
        .sheet(isPresented: $showDetail) {
            ItemDetailView(persistentStore: persistentStore, item: item)
        }
    }
    
    private var itemBody: some View {
        VStack (alignment: .leading, spacing: 5) {
            HStack (alignment: .firstTextBaseline, spacing: 5) {
                HStack (spacing: 10){
                    itemPackStatus
                    HStack (spacing: 5) {
                        Text(item.name)
                            .formatItemNameGreen()
                            .fixedSize()
                        statusIcon
                    }
                }
                Text("|")
                    .formatItemNameBlack()
                Text(item.brandName)
                    .formatItemNameBlack()
            }
            .lineLimit(1)
            Divider()
        }
        .padding(.top, 5)
        .padding(.leading, 15)
    }
    
    private var statusIcon: some View {
        VStack {
            if item.isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 12, height: 11)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 2)
            } else
            if item.isRegret {
                Image(systemName: "hand.thumbsdown.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.theme.regretColor)
                    .padding(.horizontal, 2)
            } else
            if item.isWishlist {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.yellow)
                    .padding(.horizontal, 2)
            }
        }
    }

    private var itemPackStatus: some View {
        ZStack (alignment: .center){
            if isPacked == true {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.theme.green)
                    .frame(width: 12, height: 12)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(Color.theme.green)
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    private var itemDetailContextButton: some View {
        Button {
            self.showDetail.toggle()
        } label: {
            Text("Item Detail")
        }
        
    }
    
    private var deleteContextButton: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation {
                    viewModel.removeItemFromContainer(item: item, container: container)
                }
            })
        } label: {
            HStack {
                Text("Remove from Pack")
                Image(systemName: "trash")
            }
        }
        
    }
}


