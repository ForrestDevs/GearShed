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
    @EnvironmentObject var tabManager: TabBarManager
    @StateObject private var viewModel: GearShedData
            
    // For tab bar
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private var bottomEdge: CGFloat
    
    init(bottomEdge: CGFloat, persistentStore: PersistentStore) {
        self.bottomEdge = bottomEdge
        
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
        .padding(.vertical, 5)
        .offset(x: 45)
        .background(Color.theme.green)
        .padding(.vertical, 15)
    }
    
    private var itemsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
            // Geometry Reader for calculating Offset...
            .overlay(
                GeometryReader{ proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    // Your Own Duration to hide tabbar....
                    let durationOffset: CGFloat = 35
                    DispatchQueue.main.async {
                        if minY < offset{
                            if offset < 0 && -minY > (lastOffset + durationOffset){
                                // HIding tab and updating last offset...
                                withAnimation(.easeOut.speed(1.5)){
                                    tabManager.hideTab = true
                                }
                                lastOffset = -offset
                            }
                        }
                        
                        // Same ....
                        if minY > offset && -minY < (lastOffset - durationOffset){
                            // Showing tab and updating last offset...
                            withAnimation(.easeOut.speed(1.5)){
                                tabManager.hideTab = false
                            }
                            lastOffset = -offset
                        }
                        self.offset = minY
                    }
                    return Color.clear
                }
            )
            // Same as Bottom Tab Calcu...
            .padding(.bottom,15 + bottomEdge + 35)
        }
        .coordinateSpace(name: "SCROLL")
    }
}
