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
    
    @State var selectedCategory: Category? = nil

    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    HStack {
                        NavigationLink(destination: AllItemsView()) {
                            Text("All")
                                .font(.headline)
                                .padding(.horizontal, 50)
                            Spacer()
                            Text("\(viewModel.allItemsInShed.count)")
                                .font(.headline)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)

                                    
                    HStack {
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
                    .padding(.top, 15)
                    
                    ForEach(viewModel.allUserCategories) { category in
                        
                        //if category.name = kUnknownCategoryName {
                        //    continue
                        //} else {
                        //
                        //}
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
                            Text("+")
                                .font(.largeTitle)
                                .frame(width: 57, height: 50)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 7)
                        }
                        .background(Color.theme.green)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3), radius: 3,x: 3,y: 3)
                    }
                }
            }
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $viewModel.isAddNewItemShowing) {
            AddOrModifyItemView(category: selectedCategory).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
        .fullScreenCover(isPresented: $viewModel.isEditCategoryShowing) {
            NavigationView {
                AddCategoryView()
            }
        }
    }
}

