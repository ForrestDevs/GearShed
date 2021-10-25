//
//  AllBrandView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllBrandView: View {
    
    @StateObject private var viewModel: MainCatelogVM
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ZStack {
                brandList
                addBrandOverlay
            }
            Spacer(minLength: 50)
        }
        .fullScreenCover(isPresented: $viewModel.isEditBrandShowing) {
            NavigationView {
                AddBrandView()
            }
        }
    }
    
    var brandList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.brands) { brand in
                BrandRowView(brand: brand)
                    .padding(.top, 10)
            }
        }
    }
    
    var addBrandOverlay: some View {
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
    
}

