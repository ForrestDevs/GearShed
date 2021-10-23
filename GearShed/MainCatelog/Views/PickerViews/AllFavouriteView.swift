//
//  AllTagView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllFavouriteView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // FetchRequest To Keep List of categories Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allFavItemsFR())
    private var allFavItems: FetchedResults<Item>

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(allFavItems) { item in
                    ItemRowView(item: item)
                        .padding(.top, 10)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
    }
}
