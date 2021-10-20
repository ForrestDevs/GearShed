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
                ForEach(viewModel.allItemsInShed) { item in
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




