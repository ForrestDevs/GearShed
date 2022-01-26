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
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    let persistentStore: PersistentStore
        
    @StateObject private var viewModel: GearShedData
    
    @State private var editableData: EditableItemData
    
    @State private var date: Date? = nil

    @State private var showOverlay = false
    
    @State private var selection = ""
    
    var body: some View {
        NavigationView {
            contentLayer
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButtonToolbarItem
                viewTitle
                saveButtonToolbarItem
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    // MARK: Main Content
    private var contentLayer: some View {
        ZStack {
            Color.theme.silver
                .ignoresSafeArea()
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 10) {
                    itemNameSection
                    itemBrandSection
                    itemShedSection
                    itemWeightSection
                    itemPriceSection
                    itemPurchaseDateSection
                    itemDescriptionSection
                    itemWishlistSection
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
    
    // MARK: Content Components
    private var itemNameSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Name")
                    .formatEntryTitle()
                TextField("Gear Name (Required)", text: $editableData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
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
                        detailManager.secondaryContent = AnyView (
                            AddBrandView (
                                persistentStore: persistentStore,
                                brandOut: { brand in editableData.brand = brand })
                                .environmentObject(detailManager)
                        )
                        withAnimation {
                            detailManager.tertiaryTarget = .showSecondaryContent
                        }
                    } label: {
                        Text("Add New Brand")
                            .font(.subheadline)
                    }
                    ForEach(viewModel.brands) { brand in
                        Button {
                            editableData.brand = brand
                        } label: {
                            HStack {
                                Text(brand.name)
                                    .tag(brand)
                                    .font(.subheadline)
                                if editableData.brand == brand {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text(editableData.brand?.name ?? "Select Brand (Required)")
                        .font(.subheadline)
                        .foregroundColor(brandTextColor())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(8)
                }
                .background(Color.theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                )
            }
            
        }

    }
    
    private var itemShedSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Shed")
                    .formatEntryTitle()
                Menu {
                    Button {
                        detailManager.content = AnyView (
                            AddShedView (
                                persistentStore: persistentStore,
                                shedOut: { shed in editableData.shed = shed })
                                .environmentObject(detailManager)
                        )
                        withAnimation {
                            detailManager.tertiaryTarget = .showContent
                        }
                    } label: {
                        Text("Add New Shed")
                        .font(.subheadline)
                    }
                    ForEach(viewModel.sheds) { shed in
                        Button {
                            editableData.shed = shed
                        } label: {
                            HStack {
                                Text(shed.name)
                                    .tag(shed)
                                    .font(.subheadline)
                                if editableData.shed == shed {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                        }
                    }
                } label: {
                    Text(editableData.shed?.name ?? "Select Shed (Required)")
                        .font(.subheadline)
                        .foregroundColor (shedTextColor())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(8)
                }
                .background(Color.theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                )
            }
        }

    }
    
    private var itemWeightSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Weight")
                    .formatEntryTitle()
                
                if (persistentStore.stateUnit == "g") {
                    TextField("Weight in g", text: $editableData.weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .font(.subheadline)
                        .keyboardType(.decimalPad)
                }
                
                if (persistentStore.stateUnit == "lb + oz") {
                    HStack (spacing: 10) {
                        TextField("lb", text: $editableData.lbs)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.subheadline)
                            .keyboardType(.decimalPad)
                        
                        TextField("oz", text: $editableData.oz)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.subheadline)
                            .keyboardType(.decimalPad)
                    }
                }
                
                
            }
        }
    }
    
    private var itemPriceSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Price")
                    .formatEntryTitle()

                TextField("Price in $", text: $editableData.price)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var itemPurchaseDateSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Purchase Date")
                    .formatEntryTitle()
                Button {
                    detailManager.secondaryContent = AnyView (
                        CustomDatePicker(singleDay: self.$date)
                            .zIndex(1)
                            .environmentObject(detailManager)
                    )
                    withAnimation {
                        detailManager.secondaryTarget = .showSecondaryContent
                    }
                } label: {
                    Text("\(date?.dateText(style: .short) ?? "Select Purchase Date")")
                        .font(.subheadline)
                        .foregroundColor(purchaseDateTitleColor())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(8)
                        .onChange(of: date) { newValue in
                            editableData.datePurchased = newValue
                        }
                        
                }
                .background(Color.theme.background)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.theme.boarderGrey, lineWidth: 0.5)
                )
                
                
            }
        }
    }
    
    private var itemDescriptionSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Description")
                    .formatEntryTitle()
                TextField("Gear Description", text: $editableData.details)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
            }
        }
    }
    
    private var itemWishlistSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 10) {
                Text("Add to Wishlist?")
                    .formatEntryTitle()
                Toggle(isOn: $editableData.isWishlist) {EmptyView()}.labelsHidden()
            }
        }
    }
    
    // MARK: Private Methods
    private func brandTextColor() -> Color {
        var color: Color
        if editableData.brand == nil {
            color = Color.theme.promptText
        } else {
            color = Color.theme.accent
        }
        return color
    }
    
    private func shedTextColor() -> Color {
        var color: Color
        if editableData.shed == nil {
            color = Color.theme.promptText
        } else {
            color = Color.theme.accent
        }
        return color
    }
    
    private func purchaseDateTitleColor() -> Color {
        var color: Color
        if editableData.datePurchased == nil {
            color = Color.theme.promptText
        } else {
            color = Color.theme.accent
        }
        return color
    }

    // MARK: ToolbarItems
    private var cancelButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Gear")
                .formatGreen()
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.target = .noView
                }
                viewModel.addNewItem(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
}

extension AddItemView {
    /// Intializer for passing in a shed
    init(persistentStore: PersistentStore, shedIn: Shed) {
        self.persistentStore = persistentStore
                
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore, shedInEdit: shedIn)
        _editableData = State(initialValue: initialValue)
                
    }
    
    /// Intializer for passing in a brand
    init(persistentStore: PersistentStore, brandIn: Brand) {
        self.persistentStore = persistentStore
        
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore, brandInEdit: brandIn)
        _editableData = State(initialValue: initialValue)
                
    }

    /// Intializer for passing in the whishlist selected
    init(persistentStore: PersistentStore, wishlist: Bool) {
        self.persistentStore = persistentStore

        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore, wishlistInEdit: true)
        
        _editableData = State(initialValue: initialValue)
    }
    
    /// Intializer for standard add Item View
    init(persistentStore: PersistentStore, standard: Bool) {
        self.persistentStore = persistentStore

        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialValue = EditableItemData(persistentStore: persistentStore)
        
        _editableData = State(initialValue: initialValue)
    }
}

