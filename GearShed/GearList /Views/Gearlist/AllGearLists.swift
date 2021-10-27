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

    @StateObject private var viewModel: GearlistData
    
    @State private var isAddListShowing: Bool = false
    
    @State private var isAlertShowing: Bool = false
    
    @State private var newListName: String = ""
    
    @State private var gearlist1: Gearlist? = nil
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    gearlistList
                }
                addListOverlay
                AZAlert(title: "Rename List", isShown: $isAlertShowing, text: $newListName) { text in
                    gearlist1?.updateName(gearlist: gearlist1!, name: text)
                    newListName = ""
                }
            }.padding(.bottom, 50)
            Rectangle()
               .opacity(0)
               .frame(height: 50)
        }
        .fullScreenCover(isPresented: $isAddListShowing) {
            NavigationView {
                AddListView(persistentStore: persistentStore)
            }
        }
    }
    
    var gearlistList: some View {
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
    
    var addListOverlay: some View {
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
    
}

