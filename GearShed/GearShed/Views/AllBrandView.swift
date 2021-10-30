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

    @EnvironmentObject var tabManager: TabBarManager
    
    @StateObject private var viewModel: GearShedData
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newBrandName: String = ""
    
    @State private var brand1: Brand? = nil
    
    // For tab bar
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private var bottomEdge: CGFloat
    
    // Local state to trigger showing a view to Edit Brand
    @State private var isAddBrandShowing = false
    
    init(bottomEdge: CGFloat, persistentStore: PersistentStore) {
        self.bottomEdge = bottomEdge
        
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
                alertOverlay
            }
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
    
    private var alertOverlay: some View {
        AZAlert(title: "Rename Brand", isShown: $isAlertShowing, text: $newBrandName) { text in
            brand1?.updateName(brand: brand1!, name: text)
            newBrandName = ""
        }
    }
}

