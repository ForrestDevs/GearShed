//
//  AddItemToTripSheet.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddItemToTripSheet: View {
    
    @StateObject var vm = ViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    // this is the @FetchRequest that ties this view to Core Data Items
    @FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
    private var itemsToBePurchased: FetchedResults<Item>
    
    // this is a temporary holding array for items being added to a trip.  it's a
    // @State variable, so if any SelectableItemRowView or a context menu adds an Item
    // to this array, we will get some redrawing + animation;
    @State private var itemsChecked: [Item] = []
    
    // all editableData is packaged here. its initial values are set using
    // a custom init.
    @State private var editableGearlistData: EditableGearlistData
    
    var gearlist: Gearlist
    
    // custom init to set up editable data
    init(gearlist: Gearlist) {
        _editableGearlistData = State(initialValue: EditableGearlistData(gearlist: gearlist))
        self.gearlist = gearlist
    }
    
    var multiSectionDisplay = true
    
    var body: some View {
        Form {
            
            Button(action: {commitData()}) {Text("Add Items To Trip")}
       // // DEV TOOL BUTTON REMOVE ON FINISHED APP
        Section(header: Text("DEVTOOL").sectionHeader()) {
            Button (action: {listItems()}) {Text("List Selected")}
        }
            
        // Section: Select Items To Add to Trip
        /*Section(header: Text("Select Items To Add To Trip").sectionHeader()) {
            VStack {
            List {
                ForEach(sectionData()) { section in
                    Section(header: Text(section.title).sectionHeader()) {
                        // display items in this shed
                        ForEach(section.items) { item in
                            // display a single row here for 'item'
                            TripItemsSelector(item: item,selected: itemsChecked.contains(item),  respondToTapOnSelector:  { handleItemSelected(item) }, respondToTapOffSelector: { handleItemUnSelected(item)})
                        }
                        // end of ForEach
                    }
                    // end of Section
                }
                // end of ForEach
            }
            // end of List
            
    //        .id(listDisplayID)
            .listStyle(InsetGroupedListStyle())
            //.background(Color(.red))
            //.environment(\.editMode, self.$editMode)
            //.alert(item: $confirmDeleteItemAlert) { item in item.alert() }
        }
                .frame(height: 400)
        }*/
            
        }
    }
    
    func listItems () {
        print(itemsChecked)
        //print(editableTripData.tripItems)
    }
    // the purpose of this function is to break out the itemsToBePurchased by section,
    // according to whether the list is displayed as a single section or in multiple
    // sections (one for each Shed that contains shopping items on the list)
    /*func sectionData() -> [SectionData] {
        
        // the easy case: if this is not a multi-section list, there will be one section with a title
        // and an array of all the items
        if !multiSectionDisplay {
            // if you want to change the sorting when this is a single section to "by name"
            // then comment out the .sorted() qualifier -- itemsToBePurchased is already sorted by //name
            let sortedItems = itemsToBePurchased
                .sorted(by: { $0.shed.name < $1.shed.name })
            return [SectionData(title: "", items: sortedItems)
            ]
        }
        
        // otherwise, one section for each shed, please.  break the data out by shed first
        let dictionaryByShed = Dictionary(grouping: itemsToBePurchased, by: { $0.shed })
        // then reassemble the sections by sorted keys of this dictionary
        var completedSectionData = [SectionData]()
        for key in dictionaryByShed.keys.sorted() {
            completedSectionData.append(SectionData(title: key.name, items: dictionaryByShed[key]!))
        }
        return completedSectionData
    }*/
    
    // The purpose of this function is to add the selected item to our temporary array itemsChecked
    func handleItemSelected(_ item: Item) {
        if !itemsChecked.contains(item) {
            itemsChecked.append(item)
        }
    }
    
    // The purpose of this function is to remove the selected item
    // from our temporary array itemsChecked, if the user unselects an item
    func handleItemUnSelected(_ item: Item) {
        self.itemsChecked.removeAll{$0.id == item.id}
    }

    func commitData() {
        presentationMode.wrappedValue.dismiss()
        vm.saveItemsToGearlist(items: itemsChecked, gearlist: gearlist)
        Gearlist.updateData(using: editableGearlistData)
    }

}
