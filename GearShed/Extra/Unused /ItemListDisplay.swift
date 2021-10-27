//
//  ItemListDisplay.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

/*import Foundation
import SwiftUI

struct ItemListDisplay: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @Binding var displayBy: Int
    
    @State var exapnded = false

	var body: some View {
		ScrollView {
            ForEach(sectionData()) { section in
                Section(header: SimpleHeaderView(label: section.title, expanded: $exapnded)) {
                    if exapnded {
                        ForEach(section.items) { item in
                            ItemRowView(item: item)
                                .contextMenu { itemContextMenu(item: item, deletionTrigger: { viewModel.confirmDeleteItemAlert = ConfirmDeleteItemAlert(item: item) }) }
                        }
                    }
				}
			}
		}
		//.listStyle(InsetGroupedListStyle())
        .alert(item: $viewModel.confirmDeleteItemAlert) { item in item.alert() }
	}
    
    // the purpose of this function is to break out the allItems by section,
    // according to whether the list is displayed as a single section or in multiple
    // sections (one for each Shed that contains shopping items on the list)
    func sectionData() -> [SectionData] {
        
        var completedSectionData = [SectionData]()
        
        if displayBy == 0 {
            completedSectionData.append(SectionData(title:"", items: viewModel.allItemsInShed))
        } else if displayBy == 1 {
            // otherwise, one section for each shed, please.  break the data out by shed first
            let dictionaryByShed = Dictionary(grouping: viewModel.allItemsInShed, by: { $0.shed })
            // then reassemble the sections by sorted keys of this dictionary
            for key in dictionaryByShed.keys.sorted() {
                completedSectionData.append(SectionData(title: key.name, items: dictionaryByShed[key]!))
            }
        } else if displayBy == 2 {
            // otherwise, one section for each brand, please.  break the data out by brand first
            let dictionaryByBrand = Dictionary(grouping: viewModel.allItemsInShed, by: { $0.brand })
            // then reassemble the sections by sorted keys of this dictionary
            for key in dictionaryByBrand.keys.sorted() {
                completedSectionData.append(SectionData(title: key.name, items: dictionaryByBrand[key]!))
            }
        }
        return completedSectionData
    }
}*/



