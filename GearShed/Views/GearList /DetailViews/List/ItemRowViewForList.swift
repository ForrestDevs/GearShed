//
//  ItemRowViewForList.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//

import SwiftUI

struct ItemRowViewForList: View {
    
    @ObservedObject var item: Item
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var isChecked: Bool
    
    init(gearlist: Gearlist, item: Item, respondToTapOnSelector: @escaping () -> (), respondToTapOffSelector: @escaping () -> () ) {
        self.item = item
        self.gearlist = gearlist
        let initialValue = gearlist.items.contains(item)
        _isChecked = State(initialValue: initialValue)
        
        self.respondToTapOnSelector = respondToTapOnSelector
        self.respondToTapOffSelector = respondToTapOffSelector
        
    }
    
    var respondToTapOnSelector: () -> ()
    var respondToTapOffSelector: () -> ()
    
    var body: some View {
        Button {
            isChecked = !isChecked
            if isChecked {
                respondToTapOnSelector()
            } else {
                respondToTapOffSelector()
            }
        } label: {
            HStack (alignment: .firstTextBaseline , spacing: 15) {
                itemSelectorButton
                itemRowView
                Spacer()
            }
        }
    }
    
    private var itemSelectorButton: some View {
        Image(systemName: isChecked ? "circle.fill" : "circle")
            .resizable()
            .frame(width: 13, height: 12)
            .foregroundColor(Color.theme.green)
    }
    
    private var itemRowView: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(item.name)
                    .foregroundColor(Color.theme.green)
                Text("|")
                Text(item.brandName)
                    .foregroundColor(Color.theme.accent)
            }
            .lineLimit(1)
            .fixedSize()
            HStack {
                Text("\(item.weight)g")
                    .font(.caption)
                    .foregroundColor(Color.theme.green)
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .lineLimit(1)
        }
    }
    
}
