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
   
    init(persistentStore: PersistentStore) {
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ZStack {
                gearlistList
                addListButtonOverlay
            }
        }
        .fullScreenCover(isPresented: $isAddListShowing) {
            AddListView(persistentStore: persistentStore)
        }
    }
}

extension AllGearLists {
    
    private var gearlistList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack (alignment: .leading, spacing: 5) {
                ForEach(viewModel.gearlists) { gearlist in
                    GearlistRowView(gearlist: gearlist)
                        .padding(.top, 15)
                }
            }
            .padding(.bottom, 75)
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
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
}




//@State private var isAlertShowing: Bool = false
 //@State private var newListName: String = ""
 //@State private var gearlist1: Gearlist? = nil
 //@State private var activateAddItems: Bool = false
/*private var renameListAlertOverlay: some View {
    AZAlert(title: "Rename List", isShown: $isAlertShowing, text: $newListName) { text in
        //gearlist1?.updateName(gearlist: gearlist1!, name: text)
        newListName = ""
    }
}*/


