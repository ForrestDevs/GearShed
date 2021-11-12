//
//  AllBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllBrandView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var isAddBrandShowing = false
        
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                brandList
                addBrandOverlay
            }
        }
        .fullScreenCover(isPresented: $isAddBrandShowing) {
            AddBrandView(persistentStore: persistentStore)
                .environment(\.managedObjectContext, persistentStore.context)
        }
    }
}

extension AllBrandView {
    
    private var statBar: some View {
        HStack {
            Text("Brands:")
            Text("\(viewModel.brands.count)")
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
    
    private var brandList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.brands) { brand in
                    BrandRowView(brand: brand)
                }
            }
            .padding(.bottom, 15)
            .padding(.top, 10)
        }
    }
    
    private var addBrandOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button { isAddBrandShowing.toggle()}
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("Brand")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.black.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
}

