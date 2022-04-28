//
//  SelectableItemRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-27.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct SelectableItemRowView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @State private var isChecked: Bool
    private var item: Item
    private var gearlist: Gearlist?
    private var pile: Pile?
    private var pack: Pack?
    private var type: SelectType
    var respondToTapOnSelector: () -> ()
    var respondToTapOffSelector: () -> ()
    
    init(type: SelectType, gearlist: Gearlist? = nil, pile: Pile? = nil , pack: Pack? = nil, item: Item, respondToTapOnSelector: @escaping () -> (), respondToTapOffSelector: @escaping () -> ()) {
        self.item = item
        self.type = type
        if let gearlist = gearlist {
            self.gearlist = gearlist
        }
        if let pile = pile {
            self.pile = pile
        }
        if let pack = pack {
            self.pack = pack
        }
        switch type {
        case .gearlistItem:
            let initialValue = gearlist!.items.contains(item)
            _isChecked = State(initialValue: initialValue)
        case .pileItem:
            let initialValue = pile!.items.contains(item)
            _isChecked = State(initialValue: initialValue)
        case .packItem:
            let initialValue = pack!.items.contains(item)
            _isChecked = State(initialValue: initialValue)
        }
        self.respondToTapOnSelector = respondToTapOnSelector
        self.respondToTapOffSelector = respondToTapOffSelector
    }
    
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
    //MARK: Main Content
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
                if (Prefs.shared.weightUnit == "g") {
                    if (Int(item.weight) ?? 0 > 0) {
                        Text("\(item.weight)g")
                            .font(.caption)
                            .foregroundColor(Color.theme.green)
                    }
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
                        Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
                            .font(.caption)
                            .foregroundColor(Color.theme.green)
                    }
                }
                Text(item.detail)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .lineLimit(1)
        }
    }
}
