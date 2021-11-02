//
//  AddorModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    // this editableData struct contains all of the fields of an Item that
    // can be edited here, so that we're not doing a "live edit" on the Item.
    @State private var editableItemData: EditableItemData
    @State private var shedNavLinkActive: Bool = false
    @State private var brandNavLinkActive: Bool = false
        
    init(persistentStore: PersistentStore, initialItemName: String? = nil, initialItemDetails: String? = nil, shed: Shed? = nil, brand: Brand? = nil, wishlist: Bool? = nil) {
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        // here's we'll see if a suggested name for adding a new item was supplied
        let initialValue = EditableItemData(initialItemName: initialItemName, initialItemDetails: initialItemDetails, shed: shed, brand: brand, wishlist: wishlist)
        _editableItemData = State(initialValue: initialValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 20) {
                    itemNameFeild
                    itemWeightPriceFeild
                    itemShedBrandFeild
                    itemWishlistToggle
                    itemPurchaseDateFeild
                    itemDetailsFeild
                }
                .padding()
                .navigationBarTitle("Add New Item", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { cancelButton() }
                    ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableItemData.canBeSaved) }
                }
                .onAppear {
                    logAppear(title: "AddOrModifyItemView")
                }
                .onDisappear {
                    logDisappear(title: "AddOrModifyItemView")
                    PersistentStore.shared.saveContext()
                }
            }
        }
    }

}

extension AddItemView {
    private var itemNameFeild: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Item Name")
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
                
            TextField("Add Item Name", text: $editableItemData.name)
                .foregroundColor(Color.theme.green)
                .font(.custom("HelveticaNeue", size: 17).bold())
                .disableAutocorrection(true)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: editableItemData.name.isEmpty ? 1 : 2)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var itemShedBrandFeild: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Shed")
                    .font(.subheadline)
                
                Menu {
                    Button {
                        shedNavLinkActive.toggle()
                    } label: {
                        Text("Add New Shed")
                        .font(.subheadline)
                    }
                    ForEach(viewModel.sheds) { shed in
                        Button {
                            editableItemData.shed = shed
                        } label: {
                            Text(shed.name)
                                .tag(shed)
                                .font(.subheadline)
                        }
                    }
                } label: {
                    HStack {
                        Text(editableItemData.shed.name)
                            .formatGreen()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.theme.accent)
                    }
                }
                .background(
                    NavigationLink(destination: AddShedView(shedOut: { shed in editableItemData.shed = shed }, isAddFromItem: true), isActive: $shedNavLinkActive) {
                        EmptyView()
                    }
                )
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Brand")
                    .font(.subheadline)
                
                Menu {
                    Button {
                        brandNavLinkActive.toggle()
                    } label: {
                        Text("Add New Brand")
                            .font(.subheadline)
                    }
                    ForEach(viewModel.brands) { brand in
                        Button {
                            editableItemData.brand = brand
                        } label: {
                            Text(brand.name)
                                .tag(brand)
                                .font(.subheadline)
                        }
                    }
                } label: {
                    HStack {
                        Text(editableItemData.brand.name)
                            .formatGreen()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.theme.accent)
                    }
                }
                .background(
                    NavigationLink(destination: AddBrandView(brandOut: { brand in editableItemData.brand = brand }, isAddFromItem: true), isActive: $brandNavLinkActive) {
                        EmptyView()
                    }
                )
            }
        }
    }
    
    private var itemWeightPriceFeild: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text ("Weight")
                    .font(.subheadline)
                Spacer()
                Text("Price")
                    .font(.subheadline)
                Spacer()
            } // Title
            HStack {
                VStack {
                    TextField("Add Item Weight", text: $editableItemData.weight)
                        .foregroundColor(Color.theme.green)
                        .font(.custom("HelveticaNeue", size: 17).bold())
                        .disableAutocorrection(true)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: editableItemData.weight.isEmpty ? 1 : 2)
                        .foregroundColor(Color.theme.accent)
                }
                Spacer()
                VStack {
                    TextField("Add Item Price", text: $editableItemData.price)
                        .foregroundColor(Color.theme.green)
                        .font(.custom("HelveticaNeue", size: 17).bold())
                        .disableAutocorrection(true)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: editableItemData.price.isEmpty ? 1 : 2)
                        .foregroundColor(Color.theme.accent)
                }
            } // Text Feilds
        }
    }
    
    private var itemWishlistToggle: some View {
        Toggle(isOn: $editableItemData.wishlist) {
            Text("Wishlist Item?")
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var itemPurchaseDateFeild: some View {
        DatePicker(selection: $editableItemData.datePurchased, displayedComponents: .date) {
            Text("Purchase Date")
                .font(.subheadline)
        }
    }
    
    private var itemDetailsFeild: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Item Details:")
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
            ZStack {
                if editableItemData.details.isEmpty == true {
                    Text("placeholder")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .foregroundColor(Color.theme.secondaryText)
                }
                TextEditor(text: $editableItemData.details)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, -5)
            }
            .foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
        }
    }
    
    private func cancelButton() -> some View {
        Button("Cancel",action: {presentationMode.wrappedValue.dismiss()})
    }
    
    private func saveButton() -> some View {
        Button("Save", action: commitDataEntry)
    }
    
    private func commitDataEntry() {
        guard editableItemData.canBeSaved else { return }
        
        Item.updateData(using: editableItemData)
        
        presentationMode.wrappedValue.dismiss()
    }
}




