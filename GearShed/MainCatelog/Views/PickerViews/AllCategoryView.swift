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

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.allCategories) { category in
                    CategoryRowView(category: category)
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

