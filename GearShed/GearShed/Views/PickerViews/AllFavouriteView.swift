//
//  AllTagView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllFavouriteView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    // FetchRequest To Keep List of categories Updated
    @FetchRequest(fetchRequest: MainCatelogVM.allFavItemsFR())
    private var allFavItems: FetchedResults<Item>

    var body: some View {
        VStack {
            
            StatBarInFav()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(sectionData()) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRowView(item: item)
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
            
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
    }
    
    func sectionData() -> [SectionData] {
        
        var completedSectionData = [SectionData]()
        
        // otherwise, one section for each category, please.  break the data out by category first
        let dictionaryByCategory = Dictionary(grouping: viewModel.allFavItems, by: { $0.category })
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByCategory.keys.sorted() {
            completedSectionData.append(SectionData(title: key.name, items: dictionaryByCategory[key]!))
        }
        
        return completedSectionData
    }
    
}


/*ScrollView(.vertical, showsIndicators: false) {
    ForEach(allFavItems) { item in
        ItemRowView(item: item)
            .padding(.top, 10)
    }
}*/
