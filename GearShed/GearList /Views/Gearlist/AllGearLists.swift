//
//  TripListDisplay.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllGearLists: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    @EnvironmentObject var tabManager: TabBarManager

    @StateObject private var viewModel: GearlistData
    
    @State private var isAddListShowing: Bool = false
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newListName: String = ""
    
    @State private var gearlist1: Gearlist? = nil
    
    @State private var activateAddItems: Bool = false
    
    // For tab bar
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private var bottomEdge: CGFloat
    
    init(bottomEdge: CGFloat, persistentStore: PersistentStore) {
        self.bottomEdge = bottomEdge
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    gearlistList
                }
                addListButtonOverlay
                renameListAlertOverlay
                //addListAlertOverlay
            }.padding(.bottom, 50)
            Rectangle()
               .opacity(0)
               .frame(height: 50)
        }
        .onAppear {
            tabManager.hideTab = false
        }
        .fullScreenCover(isPresented: $isAddListShowing) {
            NavigationView {
                AddListView(persistentStore: persistentStore)
            }
        }
    }
    
    private var gearlistList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.gearlists) { gearlist in
                    GearlistRowView(gearlist: gearlist)
                        .padding(.top, 15)
                        .contextMenu{ listRowContextMenu(editTrigger: {
                            gearlist1 = gearlist
                            isAlertShowing = true
                        }, deletionTrigger: {
                            Gearlist.delete(gearlist)
                        })}
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
    }
    
    private var addListButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isAddListShowing.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("List")
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
    
    private var renameListAlertOverlay: some View {
        AZAlert(title: "Rename List", isShown: $isAlertShowing, text: $newListName) { text in
            gearlist1?.updateName(gearlist: gearlist1!, name: text)
            newListName = ""
        }
    }
    
    /*private var addListAlertOverlay: some View {
        AZAlert(title: "Add New List", isShown: $isAddListShowing, text: $newListName) { text in
            let gearlist = Gearlist.newGearlist(name: text)
            activateAddItems = true
            
            NavigationLink(isActive: $activateAddItems) {
                AddMoreItemView(persistentStore: persistentStore, gearlist: gearlist)
            } label: {
                EmptyView()
            }

        }
    }*/
}

