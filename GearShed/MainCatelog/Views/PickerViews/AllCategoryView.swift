//
//  AllCategoryView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-18.
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

struct AllCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AllCategoryView()
    }
}
