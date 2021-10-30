//
//  AllRegretsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import SwiftUI

struct AllRegretsView: View {
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
                Text("\(viewModel.regretItems.count)")
            }
            HStack {
                Text("Invested:")
                Text("$\(viewModel.totalCost(array: viewModel.regretItems))")
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
                ForEach(viewModel.sectionByShed(itemArray: viewModel.regretItems)) { section in
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
