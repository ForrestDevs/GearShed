//
//  AllShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllShedView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager

    @StateObject private var viewModel: GearShedData
    
    @State private var isAddShedShowing: Bool = false
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newShedName: String = ""
    
    @State private var shed1: Shed? = nil
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    var bottomEdge: CGFloat
    
    init(bottomEdge: CGFloat, persistentStore: PersistentStore) {
        self.bottomEdge = bottomEdge
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                shedList
                    .padding(.top, 5)
                    .padding(.horizontal, 20)
                addShedOverLay
                alertOverlay
            }
        }
        .fullScreenCover(isPresented: $isAddShedShowing) {
            NavigationView {
                AddShedView()
            }
        }
    }
    
    private var statBar: some View {
        HStack {
            Text("Sheds:")
            Text("\(viewModel.sheds.count)")
            Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.vertical, 5)
        .offset(x: 45)
        .background(Color.theme.green)
        .padding(.top, 15)
    }
    
    private var shedList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.sheds) { shed in
                ShedRowView(shed: shed)
                    .padding(.top, 10)
                    .contextMenu{ shedRowContextMenu(editTrigger: {
                        shed1 = shed
                        isAlertShowing = true
                    }, deletionTrigger: {
                        Shed.delete(shed)
                    })}
            }
            // Geometry Reader for calculating Offset...
            .overlay( GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
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
                        if minY > offset && -minY < (lastOffset - durationOffset) {
                            withAnimation(.easeOut.speed(1.5)) {
                                tabManager.hideTab = false
                            }
                            lastOffset = -offset
                        }
                        
                        self.offset = minY
                    }
                    return Color.clear
                } )
            // Same as Bottom Tab Calcu...
            .padding(.bottom,15 + bottomEdge + 35)
        }
        .coordinateSpace(name: "SCROLL")
    }
    
    private var addShedOverLay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isAddShedShowing.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("Shed")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
    private var alertOverlay: some View {
        AZAlert(title: "Rename Shed", isShown: $isAlertShowing, text: $newShedName) { text in
            shed1?.updateName(shed: shed1!, name: text)
            newShedName = ""
        }
    }
}


