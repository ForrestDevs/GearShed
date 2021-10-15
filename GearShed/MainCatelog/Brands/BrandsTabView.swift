//
//  BrandsTabView.swift
//  ShoppingList
//
//
//

import SwiftUI

struct BrandsTabView: View {
    
    // this is the @FetchRequest that ties this view to CoreData Brands
    @FetchRequest(fetchRequest: Brand.allBrandsFR())
    private var brands: FetchedResults<Brand>
    
    
    /* //////////////////////////////// */
    // local state to trigger a sheet to appear to add a new brand
    @State private var isAddNewBrandSheetShowing = false
    
    // parameters to control triggering an Alert and defining what action
    // to take upon confirmation
    //@State private var confirmationAlert = ConfirmationAlert(type: .none)
    @State private var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?

    // this implements a seemingly well-known strategy to get the list drawn
    // cleanly without any highlighting
    @State private var listDisplayID = UUID()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. add new brand "button" is at top.  note that this will put up the
            // AddorModifyBrandView inside its own NavigationView (so the Picker will work!)
            Button(action: { isAddNewBrandSheetShowing = true }) {
            //    Text("Add New Brand")
            //        .foregroundColor(Color.blue)
            //        .padding(10)
            }
            .sheet(isPresented: $isAddNewBrandSheetShowing) {
                NavigationView { AddOrModifyBrandView() }
            }
            
            Rectangle()
                .frame(height: 1)
            
            
            // 2. then the list of brands
            Form {
                Section(header: Text("Brands Listed: \(brands.count)").sectionHeader()) {
                    ForEach(brands) { brand in
                        NavigationLink(destination: AddOrModifyBrandView(brand: brand)) {
                            BrandRowView(rowData: BrandRowData(brand: brand))
                                .contextMenu { contextMenuButton(for: brand) }
                        } // end of NavigationLink
                    } // end of ForEach
                } // end of Section
            } // end of Form
            //                .id(listDisplayID)
            
        } // end of VStack
        .navigationBarTitle("Brands")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing, content: addNewButton) }
        //.alert(isPresented: $confirmationAlert.isShowing) { confirmationAlert.alert() }
        .alert(item: $confirmDeleteBrandAlert) { item in item.alert() }
        .onAppear {
            logAppear(title: "BrandsTabView")
            handleOnAppear()
        }
        .onDisappear() {
            logDisappear(title: "BrandsTabView")
            PersistentStore.shared.saveContext()
        }
        
    } // end of var body: some View
    
    func handleOnAppear() {
        // updating listDisplayID makes SwiftUI think the list of brands is a whole new
        // list, thereby removing any highlighting.
        listDisplayID = UUID()
        // because the unknown brand is created lazily, this will make sure that
        // we'll not be left with an empty screen
        if brands.count == 0 {
            let _ = Brand.unknownBrand()
        }
    }
    
    // defines the usual "+" button to add a Brand
    func addNewButton() -> some View {
        Button(action: { isAddNewBrandSheetShowing = true }) {
            Image(systemName: "plus")
                .font(.title2)
        }
    }
    
    // a convenient way to build this context menu without having it in-line
    // in the view code above
    @ViewBuilder
    func contextMenuButton(for brand: Brand) -> some View {
        Button(action: {
            if !brand.isUnknownBrand {
                confirmDeleteBrandAlert = ConfirmDeleteBrandAlert(brand: brand)
            }
        }) {
            Text(brand.isUnknownBrand ? "(Cannot be deleted)" : "Delete This Brand")
            Image(systemName: brand.isUnknownBrand ? "trash.slash" : "trash")
        }
    }
    
}
