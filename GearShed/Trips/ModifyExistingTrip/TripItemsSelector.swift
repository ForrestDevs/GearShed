//
//  SelectableItemRowViewInTrip.swift
//  ShoppingList
//
//  Created by Luke Forrest Gannon on 2021-10-05.
//  Copyright © 2021 Jerry. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - SelectableItemRowViewInTrip

struct TripItemsSelector: View {
    
    // incoming are an item, whether that item is selected or not, what symbol
    // to use for animation, and what to do when the selector is tapped.  we treat
    // the item as an @ObservedObject: we want to get redrawn if any property changes.
    
    @State var isChecked: Bool = false
    
    @ObservedObject var item: Item
    var selected: Bool
    var respondToTapOnSelector: () -> ()
    var respondToTapOffSelector: () -> ()
    
    var body: some View {
        HStack {
            // Color Bar
            Color(item.uiColor)
                .frame(width: 10, height: 36)
            // Item Name and Category
            VStack(alignment: .leading) {
                
                if item.isAvailable {
                    Text(item.name)
                } else {
                    Text(item.name)
                        .italic()
                        .strikethrough()
                }
                
                Text(item.categoryName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            // --- build the little circle to tap on the right
            ZStack {
                //Image(systemName: "plus")
                    //.foregroundColor(Color(item.uiColor))
                    //.font(.title)
                if isChecked {
                    Image(systemName: "checkmark")
                } else {
                    Image(systemName: "plus")
                }
                
                
                //if selected {
                //    Image(systemName: "circle.fill")
                //        .foregroundColor(.blue)
                //        .font(.title)
                //}
                //if selected {
                //    Image(systemName: "purchased")
                //        .foregroundColor(.white)
                //        .font(.subheadline)
                //}
            } // end of ZStack
            //.animation(Animation.easeInOut(duration: 0.5))
            //.frame(width: 24, height: 24)
            .onTapGesture { toggle() }
            
            /*Button(action: toggle) {
                    Image(systemName: isChecked ? "checkmark": "plus")
            }*/
        } // end of HStack
    }
    
    func toggle() {
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


struct TESTVIEW1: View {
        @State var items = ["Pizza", "Spaghetti", "Caviar"]
        @State var selection = Set<String>()
        
        var body: some View {
            VStack {
                
            List(items, id: \.self, selection: $selection) { (item : String) in
                
                let s = selection.contains(item) ? "√" : " "
                
                HStack {
                    Text(s+item)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if  selection.contains(item) {
                        selection.remove(item)
                    }
                    else{
                        selection.insert(item)
                    }
                    print(selection)
                }
            }
            .listStyle(GroupedListStyle())
                
            Button (action: {print(selection)}) {Text("Print Selection")}
                
            Spacer()
            }
        }
}

struct TestView: View {
    
    @State var numbers = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"]
    @State var editMode = EditMode.inactive
    @State var selection = Set<String>()
    
    var body: some View {
        // 1.

            List(selection: $selection) {
                ForEach(numbers, id: \.self) { number in
                    Text(number)
                }
            }
             // 2.
            .navigationBarItems(leading: deleteButton, trailing: editButton)
             // 3.
            .environment(\.editMode, self.$editMode)
    }
    
    private var editButton: some View {
        if editMode == .inactive {
            return Button(action: {
                self.editMode = .active
                self.selection = Set<String>()
            }) {
                Text("Edit")
            }
        }
        else {
            return Button(action: {
                self.editMode = .inactive
                self.selection = Set<String>()
            }) {
                Text("Done")
            }
        }
    }
    
    private var deleteButton: some View {
        if editMode == .inactive {
            return Button(action: {}) {
                Image(systemName: "")
            }
        } else {
            return Button(action: deleteNumbers) {
                Image(systemName: "trash")
            }
        }
    }
    
    private func deleteNumbers() {
        for id in selection {
            if let index = numbers.lastIndex(where: { $0 == id })  {
                numbers.remove(at: index)
            }
        }
        selection = Set<String>()
    }
}
