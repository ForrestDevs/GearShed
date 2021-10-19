//
//  AllWishListView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllWishListView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @State private var selected = 0

    var body: some View {
        VStack (spacing: 0) {
            
            StatBar1()
                        
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.allItems) { item in
                    ItemRowView(item: item)
                }
            }
            .padding(.top, 20)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
        }
    }
}

struct AllWishListView_Previews: PreviewProvider {
    static var previews: some View {
        AllWishListView()
    }
}

struct StatBar1: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Items")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Cost")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 50)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Favourites")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }

    }
}
