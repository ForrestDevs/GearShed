//
//  ModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-22.
//  Copyright © 2021 All rights reserved.
//
import SwiftUI
import Combine

struct ModifyItemView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject var persistentStore: PersistentStore
    @StateObject private var viewModel: GearShedData
    @State private var editableData: EditableItemData
    @State private var date: Date? = nil
    init(persistentStore: PersistentStore, editableItem: Item) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let initialData = EditableItemData(persistentStore: persistentStore, item: editableItem)
        _editableData = State(initialValue: initialData)
        
        if let dateIn = editableItem.datePurchased {
            _date = State(initialValue: dateIn)
        }
    }
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
}

extension ModifyItemView {
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
                HStack {
                    Menu {
                        Button {
                            detailManager.content = AnyView (
                                AddBrandView (
                                    persistentStore: persistentStore,
                                    brandOut: { brand in editableData.brand = brand })
                                    .environmentObject(detailManager)
                            )
                            withAnimation {
                                detailManager.tertiaryTarget = .showContent
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
                    if editableData.brand != nil {
                        Button {
                            editableData.brand = nil
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
    private var itemShedSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Shed")
                    .formatEntryTitle()
                HStack {
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
                    if editableData.shed != nil {
                        Button {
                            editableData.shed = nil
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
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
    private var itemWeightSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3)  {
                Text ("Weight")
                    .formatEntryTitle()
                WeightTextField(textValueGrams: $editableData.weight, textValueLbs: $editableData.lbs, textValueOz: $editableData.oz)
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
                    .keyboardType(.decimalPad)
                    .onReceive(Just(editableData.oz)) { (newValue: String) in
                        self.editableData.oz = newValue.prefix(30).filter {"1234567890.".contains($0)  }
                    }
            }
        }
    }
    private var itemPurchaseDateSection: some View {
        Section {
            VStack (alignment: .leading, spacing: 3) {
                Text("Purchase Date")
                    .formatEntryTitle()
                HStack {
                    Button {
                        detailManager.secondaryContent = AnyView (
                            CustomDatePicker(singleDay: self.$date)
                                .environmentObject(detailManager)
                        )
                        withAnimation {
                            detailManager.tertiaryTarget = .showSecondaryContent
                        }
                    } label: {
                        Text("\(date?.monthDayYearDateText() ?? "Select Purchase Date")")
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
                    if editableData.datePurchased != nil {
                        Button {
                            editableData.datePurchased = nil
                            date = nil
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
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
                    detailManager.secondaryTarget = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Gear")
                .formatGreen()
        }
    }
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
                viewModel.updateItem(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
}
