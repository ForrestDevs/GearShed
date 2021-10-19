//
//  AllItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllItemsView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @State private var selected = 0

    var body: some View {
        VStack (spacing: 0) {
            
            StatBar()
                        
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.allItems) { item in
                    ItemRowView(item: item)
                }
            }
            .padding(.top, 10)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
        }
    }
}

struct AllItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsView()
    }
}

struct StatBar: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Items")
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
                        Text("Weight")
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
                        Text("Favourites")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItems.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }

    }
}


