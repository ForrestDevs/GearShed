//
//  AllTagView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllFavouriteView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            itemsList
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 30) {
            HStack {
                Text("Items:")
                Text("\(viewModel.favItems.count)")
            }
            HStack {
                Text("Weight:")
                Text("\(viewModel.totalWeight(array: viewModel.favItems))g")
            }
            HStack {
                Text("Invested:")
                Text("$\(viewModel.totalCost(array: viewModel.favItems))")
            }
             Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
    
    private var itemsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.sectionByShed(itemArray: viewModel.favItems)) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRowView(item: item)
                                .padding(.horizontal)
                                .padding(.bottom, 5)

                        }
                    } header: {
                        VStack (spacing: 0) {
                            HStack {
                                Text(section.title)
                                    .font(.headline)
                                Spacer()
                            }
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 75)
        }
    }
}
