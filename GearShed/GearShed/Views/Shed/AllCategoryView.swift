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

    @StateObject private var viewModel: MainCatelogVM
    
    // Local state to trigger showing a sheet to add a new item in MainCatelog
    @State private var isAddNewItemShowing: Bool = false
    
    @State private var showingUnlockView: Bool = false
    
    @State private var isAddShedShowing: Bool = false
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    //allShedRow
                    shedList
                }
                addShedOverLay
            }
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $isAddNewItemShowing) {
            AddItemView(persistentStore: persistentStore, shed:  viewModel.selectedShed).environment(\.managedObjectContext, PersistentStore.shared.context)
            //print("Injected",selectedShed?.name ?? "")
        }
        .fullScreenCover(isPresented: $isAddShedShowing) {
            NavigationView {
                AddShedView()
            }
        }
        .sheet(isPresented: $showingUnlockView) {
            UnlockView()
        }
    }
    
    var allShedRow: some View {
        HStack {
            NavigationLink(destination: AllItemsView(persistentStore: persistentStore)) {
                
                HStack {
                    Text("All")
                        .font(.headline)
                    Text("|")
                        .font(.headline)
                    Text("\(viewModel.sheds.count) Sheds")
                        .font(.headline)
                }
                .padding(.horizontal, 50)
                
                Spacer()
                Text("\(viewModel.items.count)")
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal)
        .padding(.top, 15)
    }
    
    var shedList: some View {
        ForEach(viewModel.sheds) { shed in
            HStack (alignment: .firstTextBaseline, spacing: 10) {
                Button {
                    viewModel.selectedShed = shed
                    print("AC SC", viewModel.selectedShed?.name ?? "")
                 
                    let canCreate = self.persistentStore.fullVersionUnlocked ||
                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                    if canCreate {
                        isAddNewItemShowing.toggle()
                    } else {
                        showingUnlockView.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                ShedRowView(shed: shed)
                    .padding(.top, 15)
            }
            .padding(.horizontal)
            
        }
    }
    
    var addShedOverLay: some View {
        // Add Shed Overlay
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
    
}


