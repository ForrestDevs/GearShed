//
//  ItemRowViewForList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//

import SwiftUI

struct ItemRowViewForList: View {
    @ObservedObject var item: Item
    
    @State private var isChecked: Bool = false
    
    var respondToTapOnSelector: () -> ()
    var respondToTapOffSelector: () -> ()
    
    var body: some View {
        HStack (alignment: .firstTextBaseline , spacing: 15) {
            itemSelectorButton
            itemRowView
            Spacer()
        }
    }
    
    private var itemSelectorButton: some View {
        Image(systemName: isChecked ? "circle.fill" : "circle")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
            .padding(.vertical, -1)
            .onTapGesture {
                isChecked = !isChecked
                
                if isChecked {
                    respondToTapOnSelector()
                }
                
                if !isChecked {
                    respondToTapOffSelector()
                }
                
                if isChecked {
                print("\(item.name) Is selected")
                } else {
                    print("\(item.name) Is unselected")
                }
            }
    }
    
    private var itemRowView: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(item.brandName)
                    .foregroundColor(Color.theme.accent)
                
                Text("|")
                
                Text(item.name)
                    .foregroundColor(Color.theme.green)
            }
            HStack {
                Text("\(item.weight)g")
                    .font(.caption)
                    .foregroundColor(Color.theme.green)
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .frame(maxHeight: 35)
        }
    }
    
}
