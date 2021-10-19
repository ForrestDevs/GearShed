//
//  AllBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-18.
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

struct AllBrandView_Previews: PreviewProvider {
    static var previews: some View {
        AllBrandView()
    }
}
