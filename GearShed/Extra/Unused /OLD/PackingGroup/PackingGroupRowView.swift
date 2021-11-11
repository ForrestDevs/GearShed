//
//  PackingGroupRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-07.
//

//import SwiftUI
/*
struct PackingGroupRowView: View {
    
    let persistentStore: PersistentStore
    
    let packingGroup: PackingGroup
    
    @StateObject private var viewModel: GearlistData
                
    init(persistentStore: PersistentStore, packingGroup: PackingGroup) {
        self.persistentStore = persistentStore
        self.packingGroup = packingGroup
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            packingGroupHeader
            packingGroupItems
        }
        .padding(.horizontal)
    }
}

extension PackingGroupRowView {
    
    private var packingGroupHeader: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(packingGroup.name)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    private var packingGroupItems: some View {
        ForEach(packingGroup.items) { item in
            ItemRowViewInPackingGroup(item: item, packingGroup: packingGroup, persistentStore: persistentStore)
        }
    }
    
}

struct ItemRowViewInPackingGroup: View {
    
    let item: Item
    
    let packingGroup: PackingGroup
    
    @StateObject private var viewModel: GearlistData

    @State private var isPacked: Bool
    
    init(item: Item, packingGroup: PackingGroup, persistentStore: PersistentStore) {
        self.item = item
        self.packingGroup = packingGroup
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialState = item.packingGroupPackingBool(packingGroup: packingGroup, item: item)?.isPacked
        _isPacked = State(initialValue: initialState!)
    }
    
    var body: some View {
        HStack {
            packedButton
            itemBody
        }
        .padding(.horizontal)
    }
}

extension ItemRowViewInPackingGroup {
    
    private var packedButton: some View {
        Button {
            isPacked.toggle()
            viewModel.togglePackingBoolState(packingBool: item.packingGroupPackingBool(packingGroup: packingGroup, item: item)!)
            /*if item.packingGroupPackingBool(packingGroup: packingGroup, item: item)!.isPacked == true {
                item.packingGroupPackingBool(packingGroup: packingGroup, item: item)!.isPacked = false
            } else {
                item.packingGroupPackingBool(packingGroup: packingGroup, item: item)!.isPacked = true
            }*/
        } label: {
            ZStack {
                Rectangle()
                    .strokeBorder(Color.theme.accent, lineWidth: 2)
                    .frame(width: 25, height: 25)
                if isPacked == true {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.green)
                }
            }
        }
        
    }
    
    private var itemBody: some View {
        HStack {
            Text(item.brandName)
            Text("|")
            Text(item.name)
        }
    }
    
}
 */
