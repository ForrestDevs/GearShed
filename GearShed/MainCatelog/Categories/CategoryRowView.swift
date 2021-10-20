//
//  CategoryRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    
    @ObservedObject var category: Category

    var body: some View {
        NavigationLink(destination: CategoryDetailView(category: category)) {
            HStack {
                Text(category.name)
                    .font(.headline)
                Spacer()
                Text("\(category.itemCount)")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 20)
    }
}



