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
    
    //@State private var selected = 0

    var body: some View {
        VStack (spacing: 0) {
            
            StatBar()
                .padding(.top, 5)
                        
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(sectionData()) { section in
                    Section {
                        ForEach(section.items) { item in
                            ItemRowView(item: item)
                        }
                    } header: {
                        HStack {
                            Text(section.title)
                            Spacer()
                        }.padding(.horizontal)
                    }
                }
            }
            
            .padding(.top, 10)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
        }
    }
    
    
    
    func sectionData() -> [SectionData] {
        
        var completedSectionData = [SectionData]()
        
        // otherwise, one section for each category, please.  break the data out by category first
        let dictionaryByCategory = Dictionary(grouping: viewModel.allItemsInShed, by: { $0.category })
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByCategory.keys.sorted() {
            completedSectionData.append(SectionData(title: key.name, items: dictionaryByCategory[key]!))
        }
        
        return completedSectionData
    }
    
}


/*var body: some View {
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
}*/







