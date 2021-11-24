//
//  ModifyItemView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-22.
//

import SwiftUI

struct ModifyItemView: View {

    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var editableData: EditableItemData
    @State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
    
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
                
                Menu {
                    Button {
                        detailManager.content = AnyView (
                            AddBrandView (
                                persistentStore: persistentStore,
                                brandOut: { brand in editableData.brand = brand })
                                .environmentObject(detailManager)
                        )
                        withAnimation {
                            detailManager.showContent = true
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
                            detailManager.showContent = true
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
                TextField("Weight in g", text: $editableData.weight)
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
                    withAnimation {
                        detailManager.showSecondaryContent = true
                        detailManager.secondaryContent = AnyView (
                            CustomDatePicker(singleDay: self.$date)
                                .zIndex(1)
                                .environmentObject(detailManager)
                        )
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
                Text("Wish?")
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
                    detailManager.showModifyItem = false
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Edit Item")
                .formatGreen()
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyItem = false
                }
                viewModel.updateItem(using: editableData)
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canBeSaved)
        }
    }
    
}

/*ScrollView (.vertical, showsIndicators: false) {
    VStack (alignment: .leading, spacing: 20) {
        itemNameFeild
        itemWeightPriceFeild
        itemShedBrandFeild
        itemWishlistToggle
        itemPurchaseDateFeild
        itemDetailsFeild
        deleteItemFeild
    }
    
}*/


/*extension ModifyItemView {
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
    
    private var deleteItemFeild: some View {
        VStack {
            if editableItemData.representsExistingItem {
                
                Button {
                    
                    confirmDeleteItemAlert = ConfirmDeleteItemAlert(
                        item: editableItemData.associatedItem,
                        destructiveCompletion: {
                            presentationMode.wrappedValue.dismiss()
                            Item.delete(editableItemData.associatedItem)
                    })
                } label: {
                    Text("Delete Item")
                }
            }
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
}*/
