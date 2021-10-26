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
            
            StatBarInBrand(persistentStore: persistentStore, brand: brand)
            
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
            ForEach(sectionData()) { section in
                Section {
                    ForEach(section.items) { item in
                        ItemRowViewInBrand(item: item)
                            .padding(.bottom, 5)
                    }
                } header: {
                    VStack (spacing: 0) {
                        HStack {
                            Text(section.title)
                                .font(.headline)
                            Spacer()
                        }
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    func sectionData() -> [SectionData] {
        var completedSectionData = [SectionData]()
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByShed = Dictionary(grouping: brand.items, by: { $0.shed })
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByShed.keys.sorted() {
            completedSectionData.append(SectionData(title: key.name, items: dictionaryByShed[key]!))
        }
        return completedSectionData
    }
}


/*ScrollView(.vertical, showsIndicators: false) {
    ForEach(brand.items) { item in
        ItemRowView(item: item)
    }
}*/


