//
//  ItemDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-18.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject  private var viewModel = MainCatelogVM()
        
    @State private var selected = 1
    
    var item: Item

    var body: some View {
        VStack (alignment: .leading) {
            
            HStack {
                Text(item.brandName)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.green)
                Text(item.name)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.green)

            }
            
            Text(item.categoryName)
                .font(.caption)
                       
            StatBar4()
            
            //SPForDetailView(selected: $selected)
            
            Spacer()
        }
        .padding()
    }
}

struct StatBar4: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Weight")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count) g")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Trips")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Acquired")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Investment")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("$\(viewModel.allItems.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }

    }
}

struct SPForDetailView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button { self.selected = 0}
                    label: { Text("A ... Z")
                                .padding(.vertical,12)
                                .padding(.horizontal,30)
                                .background(self.selected == 0 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                }
                .foregroundColor(self.selected == 0 ? .green : .black)
                
                Button { self.selected = 1 }
                    label: { Text("FAVOURITES")
                                .padding(.vertical,12)
                                .padding(.horizontal,30)
                                .background(self.selected == 1 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                }
                .foregroundColor(self.selected == 1 ? .green : .black)
                
            }
        }
        .padding(5)
        .background(Color.secondary)
        .animation(.easeInOut)
        
    }
}
