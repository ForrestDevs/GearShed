//
//  TagRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-18.
//

import SwiftUI

// MARK: - TagRowData Definition
// this is a struct to transport all the incoming data about a Tag that we
// will display.  see the commentary over in EditableItemData.swift and
// SelectableItemRowView.swift about why we do this.
struct TagRowData {
    let name: String
    let itemCount: Int
    
    init(tag: Tag) {
        name = tag.name
        itemCount = tag.itemCount
    }
}

struct TagRowView: View {
    
    var rowData: TagRowData

    var body: some View {
        
        HStack {
            NavigationLink(destination: EmptyView()) {
                HStack{
                    Text(rowData.name)
                        .font(.headline)
                    Spacer()
                    Text("\(rowData.itemCount)")
                        .font(.headline)
                }
            }
            
            Button {} label: {
                Image(systemName: "square.and.pencil")
            }
            
        }
        .padding(.horizontal, 20)
    }
}


