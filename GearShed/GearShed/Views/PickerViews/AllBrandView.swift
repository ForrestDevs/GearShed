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
    
    // FetchRequest To Keep List of categories Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allUserBrandsFR(unknBrandName: kUnknownBrandName))
    private var userBrands: FetchedResults<Brand>

    var body: some View {
        VStack {
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(userBrands) { brand in
                        BrandRowView(brand: brand)
                            .padding(.top, 10)
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {viewModel.isEditBrandShowing.toggle()}
                        label: {
                            VStack{
                                Text("Add")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Color.theme.background)
                                    
                                Text("Brand")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Color.theme.background)
                            }
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.theme.accent)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3), radius: 3,x: 3,y: 3)
                    }
                }

            }
            
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $viewModel.isEditBrandShowing) {
            NavigationView {
                AddBrandView()
            }
        }
    }
}

