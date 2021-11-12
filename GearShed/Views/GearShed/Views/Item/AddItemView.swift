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
    
    let persistentStore: PersistentStore
    
    //@EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var editableItemData: EditableItemData
    
    @State private var shedNavLinkActive: Bool = false
    @State private var brandNavLinkActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                contentLayer
            }
            .navigationBarTitle("Add Item", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButtonToolbarItem
                saveButtonToolbarItem
            }
        }
    }
}

extension AddItemView {
    
    // MARK: Main Content
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var contentLayer: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 10) {
                itemNameSection
                itemBrandSection
                itemShedSection
                itemWeightSection
                itemPriceSection
                itemWishlistSection
                itemPurchaseDateSection
                itemDescriptionSection
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    // MARK: Content Components
    private var itemNameSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("", text: $editableItemData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var itemShedSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Shed")
                    .formatEntryTitle()


                Menu {
                    // Add New Shed Button
                    Button {
                        shedNavLinkActive.toggle()
                    } label: {
                        Text("Add New Shed")
                        .font(.subheadline)
                    }
                    
                    // List Of Current Sheds
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
                        Text(editableItemData.shed?.name ?? "Select Shed")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .background(
                    NavigationLink(
                        destination: AddShedView (
                            persistentStore: persistentStore,
                            shedOut: { shed in editableItemData.shed = shed },
                            isAddFromItem: true),
                        isActive: $shedNavLinkActive) {
                        EmptyView()
                    }
                )
            }
        }

    }
    
    private var itemBrandSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Brand")
                    .formatEntryTitle()


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
                        Text(editableItemData.brand?.name ?? "Select Brand")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .background(
                    NavigationLink(destination: AddBrandView(persistentStore: persistentStore, brandOut: { brand in editableItemData.brand = brand }, isAddFromItem: true), isActive: $brandNavLinkActive) {
                        EmptyView()
                    }
                )
            }
        }

    }
    
    private var itemWeightSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Weight")
                    .formatEntryTitle()


                TextField("", text: $editableItemData.weight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }

    }
    
    private var itemPriceSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Price")
                    .formatEntryTitle()

                TextField("", text: $editableItemData.price)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
                
            }
        }

    }
    
    private var itemWishlistSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 10) {
                Text("Wishlist?")
                    .formatEntryTitle()
                Toggle(isOn: $editableItemData.wishlist) {EmptyView()}.labelsHidden()
            }
        }
    }

    private var itemPurchaseDateSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Purchase Date")
                    .formatEntryTitle()

                DatePicker("Purchase Date",selection: Binding<Date>(get: {editableItemData.datePurchased ?? Date()}, set: {editableItemData.datePurchased = $0}),
                    displayedComponents: .date)
                    .disabled(editableItemData.wishlist == true)
                    .labelsHidden()
                    .pickerStyle(.wheel)
            }
        }
    }

    private var itemDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()

                TextField("", text: $editableItemData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
            }
        }
    }
    
    // MARK: ToolbarItems
    private var cancelButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.addNewItem(using: editableItemData)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableItemData.canBeSaved)
        }
    }
}

extension AddItemView {
    /// Intializer for passing in a shed
    init(persistentStore: PersistentStore, shedIn: Shed) {
        self.persistentStore = persistentStore
        
        print("\(String(describing: shedIn)) From Init")
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore, shedInEdit: shedIn)
        
        _editableItemData = State(initialValue: initialValue)
                
        print("\(String(describing: editableItemData.shed)) after Init")
    }
}

extension AddItemView {
    /// Intializer for passing in the whishlist selected
    init(persistentStore: PersistentStore, wishlist: Bool) {
        self.persistentStore = persistentStore

        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore, wishlistInEdit: true)
        
        _editableItemData = State(initialValue: initialValue)
    }
}

extension AddItemView {
    /// Intializer for standard add Item View
    init(persistentStore: PersistentStore, standard: Bool) {
        self.persistentStore = persistentStore

        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore)
        
        _editableItemData = State(initialValue: initialValue)
    }
}

/*ZStack {
    if editableItemData.details.isEmpty == true {
        Text("placeholder")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .foregroundColor(Color.theme.secondaryText)
    }
    TextEditor(text: $editableItemData.details)
        .frame(maxHeight: .infinity)
        .padding(.horizontal, -5)
}
//.foregroundColor(Color.theme.green)
.font(.custom("HelveticaNeue", size: 17).bold())*/

/*private var itemNameFeild: some View {
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
}*/

