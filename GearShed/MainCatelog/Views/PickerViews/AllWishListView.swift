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
    
    // FetchRequest To Keep List of categories Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allItemsInWishListFR())
    private var allWishListItems: FetchedResults<Item>
    
    //@State private var selected = 0

    var body: some View {
        VStack (spacing: 0) {
            
            StatBar1()
                        
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(allWishListItems) { item in
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

