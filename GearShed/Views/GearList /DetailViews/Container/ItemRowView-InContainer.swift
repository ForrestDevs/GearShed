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
    
    @State private var isPacked: Bool
    
    init(item: Item, gearlist: Gearlist) {
        self.item = item
        self.gearlist = gearlist
        
        let initialState = item.gearlistContainerBool(gearlist: gearlist)?.isPacked
        
        _isPacked = State(initialValue: initialState!)
    }
    
    var body: some View {
        HStack {
            packedButton
            itemBody
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }
}

extension ItemRowView_InContainer {
    
    private var packedButton: some View {
        Button {
            isPacked.toggle()
            viewModel.toggleContainerBoolState(containerBool: item.gearlistContainerBool(gearlist: gearlist)!)
        } label: {
            ZStack {
                Image(systemName: "circle")
                    .foregroundColor(Color.theme.green)
                /*Rectangle()
                    .strokeBorder(Color.theme.accent, lineWidth: 1)
                    .frame(width: 20, height: 20)*/
                if isPacked == true {
                    Image(systemName: "bag.circle.fill")
                        .foregroundColor(Color.theme.green)
                }
            }
        }
        
    }
    
    private var itemBody: some View {
        HStack {
            Text(item.brandName)
                .foregroundColor(Color.theme.accent)
            Text("|")
            Text(item.name)
                .foregroundColor(Color.theme.green)
        }
    }
    
}

