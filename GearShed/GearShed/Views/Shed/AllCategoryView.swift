//
//  AllCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllCategoryView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    // Local state to trigger showing a sheet to add a new item in MainCatelog
    @State private var isAddNewItemShowing: Bool = false
    
    @State private var showingUnlockView: Bool = false
    
    @State private var isAddCategoryShowing: Bool = false
    
    // state var to pass into addItemView pre populating the selected category
    @State var selectedCategory: Category? = nil
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    allShedRow
                    categoryList
                }
                addShedOverLay
            }
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $isAddNewItemShowing) {
            AddItemView(persistentStore: persistentStore, category: selectedCategory).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .fullScreenCover(isPresented: $isAddCategoryShowing) {
            NavigationView {
                AddCategoryView()
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
                    Text("\(viewModel.categories.count) Sheds")
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
    
    var categoryList: some View {
        ForEach(viewModel.categories) { category in
            HStack (alignment: .firstTextBaseline, spacing: 10) {
                Button {
                    let canCreate = self.persistentStore.fullVersionUnlocked ||
                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                    if canCreate {
                        selectedCategory = category
                        isAddNewItemShowing.toggle()
                    } else {
                        showingUnlockView.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                CategoryRowView(category: category)
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
                    isAddCategoryShowing.toggle()
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


