//
//  AllCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllCategoryView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // FetchRequest To Keep List of categories Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allCategoriesFR())
    private var allCategories: FetchedResults<Category>
    
    @State var selectedCategory: Category? = nil

    var body: some View {
        VStack {
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    HStack {
                        NavigationLink(destination: AllItemsView()) {
                            
                            HStack {
                                Text("All")
                                    .font(.headline)
                                Text("|")
                                    .font(.headline)
                                Text("\(allCategories.count) Sheds")
                                    .font(.headline) 
                            }
                            .padding(.horizontal, 50)
                            
                            Spacer()
                            Text("\(viewModel.allItemsInShed.count)")
                                .font(.headline)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)

                    /*HStack {
                        Button {viewModel.isAddNewItemShowing.toggle()} label: {
                            Image(systemName: "plus")
                        }
                        NavigationLink(destination: AllItemsView()) {
                            Text("Uncategorized")
                                .font(.headline)
                                .padding(.horizontal, 22.5)
                            Spacer()
                            
                            Text("0")
                                .font(.headline)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)*/
                    
                    ForEach(allCategories) { category in
                        HStack (alignment: .firstTextBaseline, spacing: 10) {
                            Button {
                                selectedCategory = category
                                viewModel.isAddNewItemShowing.toggle()
                            } label: {
                                Image(systemName: "plus")
                            }
                            CategoryRowView(category: category)
                                .padding(.top, 15)
                        }
                        .padding(.horizontal)
                        
                    }
                    
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {viewModel.isEditCategoryShowing.toggle()}
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
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $viewModel.isAddNewItemShowing) {
            AddItemView(category: selectedCategory).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .fullScreenCover(isPresented: $viewModel.isEditCategoryShowing) {
            NavigationView {
                AddCategoryView()
            }
        }
    }
}


    /*.font(.largeTitle)
    .frame(width: 57, height: 50)
    .foregroundColor(Color.white)
    .padding(.bottom, 7)*/
