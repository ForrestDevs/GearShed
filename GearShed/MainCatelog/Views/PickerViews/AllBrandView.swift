//
//  AllBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllBrandView: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.allBrands) { brand in
                    BrandRowView(brand: brand)
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

