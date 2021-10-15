//
//  UnusedCode.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//

/*
 
 //Section 2+3.
 
// Section(header: Text("Category").sectionHeader()) {
//     Picker(selection: $categoryChooser, label: Text("Category")) //{
//         Text("Choose Category").tag(0)
//         Text("Create New Category").tag(1)
//     }
//     .pickerStyle(SegmentedPickerStyle())
//     .onAppear {
//         if (self.categorys.count == 0) {
//             self.categoryChooser = 1
//             }
//         }
//
//     // Choose Category is selected in segemented control
//     if (categoryChooser == 0) {
//         Picker(selection: $editableItemData.category, label: //SLFormLabelText(labelText: "Category: ")) {
//             ForEach(categorys) { category in
//                 Text(category.name).tag(category)
//             }
//         }
//     }
//     // Create Category is selected in segmented control
//     if (categoryChooser == 1) {
//         HStack {
//             SLFormLabelText(labelText: "Name: ")
//             TextField("Category name", text: //$editableItemData.categoryName)
//         }
//     }
// }
 
 //Section(header: Text("Brand").sectionHeader()) {
 //    Picker(selection: $brandChooser, label: Text("Brand")) {
 //        Text("Choose Brand").tag(0)
 //        Text("Create New Brand").tag(1)
 //    }
 //    .pickerStyle(SegmentedPickerStyle())
 //    .onAppear {
 //        if (self.brands.count == 0) {
 //            self.brandChooser = 1
 //            }
 //        }
 //
 //    // Choose Brand is selected in segemented control
 //    if (brandChooser == 0) {
 //        Picker(selection: $editableItemData.brand, label: //SLFormLabelText(labelText: "Brand: ")) {
 //            ForEach(brands) { brand in
 //                Text(brand.name).tag(brand)
 //            }
 //        }
 //    }
 //    // Create Brand is selected in segmented control
 //    if (brandChooser == 1) {
 //        HStack {
 //            SLFormLabelText(labelText: "Name: ")
 //            TextField("Brand name", text: //$editableItemData.brandName)
 //        }
 //    }
 //}
 //End of Section 2+3.
 
 /*HStack(alignment: .firstTextBaseline) {
     Toggle(isOn: $editableItemData.onList) {
         SLFormLabelText(labelText: "On Shopping List: ")
     }
 }
 
 HStack(alignment: .firstTextBaseline) {
     Toggle(isOn: $editableItemData.isAvailable) {
         SLFormLabelText(labelText: "Is Available: ")
     }
 }
 
 if !editableItemData.dateText.isEmpty {
     HStack(alignment: .firstTextBaseline) {
         SLFormLabelText(labelText: "Last Purchased: ")
         Text("\(editableItemData.dateText)")
     }
 }*/
 
 /*func handleItemTapped(_ item: Item) {
     if !itemsChecked.contains(item) {
         // put the item into our list of what's about to be removed, and because
         // itemsChecked is a @State variable, we will see a momentary
         // animation showing the change.
         itemsChecked.append(item)
         // and we queue the actual removal long enough to allow animation to finish
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
             item.toggleOnListStatus()
             itemsChecked.removeAll(where: { $0 == item })
         }
     }
 }*/
 
 Brand Visitation order Section
 //if editableData.order != kUnknownBrandVisitationOrder {
 //    Stepper(value: $editableData.order, in: 1...100) {
 //        HStack {
 //            SLFormLabelText(labelText: "Visitation Order: ")
 //            Text("\(editableData.order)")
 //        }
 //    }
 //}
 
 Category Visitation order section
 
 //if editableData.visitationOrder != kUnknownCategoryVisitationOrder {
 //    Stepper(value: $editableData.visitationOrder, in: 1...100) {
 //        HStack {
 //            SLFormLabelText(labelText: "Visitation Order: ")
 //            Text("\(editableData.visitationOrder)")
 //        }
 //    }
 //}
 
 
 

 
 */
