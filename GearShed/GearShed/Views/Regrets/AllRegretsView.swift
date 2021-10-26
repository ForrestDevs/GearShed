//
//  AllRegretsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-25.
//

import SwiftUI

struct AllRegretsView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: MainCatelogVM
        
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            StatBarInRegret(persistentStore: persistentStore)
                .padding(.top, 5)

            itemsList
                .padding(.top, 10)

            Spacer(minLength: 50)
        }
    }
    
    private var itemsList: some View {
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

    }
    
    func sectionData() -> [SectionData] {
        var completedSectionData = [SectionData]()
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByShed = Dictionary(grouping: viewModel.regretItems, by: { $0.shed })
        // then reassemble the sections by sorted keys of this dictionary
        for key in dictionaryByShed.keys.sorted() {
            completedSectionData.append(SectionData(title: key.name, items: dictionaryByShed[key]!))
        }
        return completedSectionData
    }
}
