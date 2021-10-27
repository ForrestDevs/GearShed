//
//  AllBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllBrandView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newBrandName: String = ""
    
    @State private var brand1: Brand? = nil
    
    // Local state to trigger showing a view to Edit Brand
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
                    .padding(.top, 5)
                    .padding(.horizontal, 20)
                addBrandOverlay
                AZAlert(title: "Rename Brand", isShown: $isAlertShowing, text: $newBrandName) { text in
                    brand1?.updateName(brand: brand1!, name: text)
                    newBrandName = ""
                }
            }
            .padding(.bottom, 50)
        }
        .fullScreenCover(isPresented: $isAddBrandShowing) {
            NavigationView {
                AddBrandView()
            }
        }
    }
    
    private var statBar: some View {
        HStack {
            Text("Brands:")
            Text("\(viewModel.brands.count)")
            Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.vertical, 5)
        .offset(x: 45)
        .background(Color.theme.green)
        .padding(.top, 15)
    }
    
    private var brandList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.brands) { brand in
                BrandRowView(brand: brand)
                    .padding(.top, 10)
                    .contextMenu{ brandRowContextMenu(editTrigger: {
                        brand1 = brand
                        isAlertShowing = true
                    }, deletionTrigger: {
                        Brand.delete(brand)
                    })}
            }
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
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
}

