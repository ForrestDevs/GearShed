//
//  BrandDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct BrandDetailView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var brand: Brand
    
    @State private var isEditBrandShowing: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            
            StatBar(persistentStore: persistentStore)
            
            brandItems
            
            Spacer(minLength: 60)
        }
        .navigationTitle(brand.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { self.isEditBrandShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditBrandShowing) {
            ModifyBrandView(brand: brand).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
    }
    
    var brandItems: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(brand.items) { item in
                ItemRowView(item: item)
            }
        }
    }
}

