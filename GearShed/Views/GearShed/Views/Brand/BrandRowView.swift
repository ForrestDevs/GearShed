//
//  BrandRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct BrandRowView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    
    @ObservedObject var brand: Brand

    var body: some View {
        NavigationLink(destination: BrandDetailView(persistentStore: persistentStore,brand: brand)) {
            HStack{
                Text(brand.name)
                    .font(.headline)
                Spacer()
                Text("\(brand.itemCount)")
                    .font(.headline)
            }
        }
    }
}





