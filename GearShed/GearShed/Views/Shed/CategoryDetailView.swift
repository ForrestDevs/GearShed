//
//  CategoryDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var category: Category
    @State private var isEditCategoryShowing: Bool = false

    var body: some View {
        VStack(spacing:0) {
            
            StatBarInShed(persistentStore: persistentStore)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(category.items) { item in
                    ItemRowView(item: item)
                }
            }
            //.padding(.top, 20)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
                
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { isEditCategoryShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditCategoryShowing) {
            ModifyCategoryView(category: category).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
    }
}





