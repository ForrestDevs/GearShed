//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//

import SwiftUI

struct MainCatelogView: View {
    
    static let tag: String? = "MainCatelog"

    // this is the @FetchRequest that ties this view to CoreData Items
    @FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
    private var itemsInCatelog: FetchedResults<Item>

    // local state to trigger showing a sheet to add a new item
    @State private var isAddNewItemSheetShowing = false
    
    // local state for are we a multi-section display or not.  the default here is false,
    // but an eager developer could easily store this default value in UserDefaults (?)
    @State var multiSectionDisplay: Bool = true
    
    // this implements a seemingly well-known strategy to get the list drawn
    // cleanly without any highlighting
    @State private var listDisplayID = UUID()

    var body: some View {
        VStack(spacing: 0) {
                
/* ---------
1. Buttons At Top To Edit Brands and Categories
---------- */
        HStack {
            // EDIT CATEGORIES
            NavigationLink(destination: CategoriesTabView()) {
                Text("Edit Categories")
                    .foregroundColor(Color.blue)
                    .padding(10)
            }

            //EDIT BRANDS
            NavigationLink(destination: BrandsTabView()) {
                Text("Edit Brands")
                    .foregroundColor(Color.blue)
                    .padding(10)
            }
        }
/* ---------
1. Visual Spacer To Seperate NavBar and Item List
---------- */
            Rectangle()
                .frame(height: 1)
                
/* ---------
2. we display either a "List is Empty" view, a single-section shopping list view
or multi-section shopping list view.  the list display has some complexity to it because
of the sectioning, so we push it off to a specialized View.
---------- */
            if itemsInCatelog.count == 0 {
                EmptyCatelogView()
            } else {
                ItemListDisplay(multiSectionDisplay: $multiSectionDisplay)
            }
        } // end of VStack
            .navigationBarTitle("Main Catalog")
            .sheet(isPresented: $isAddNewItemSheetShowing) {
                NavigationView {
                    AddICBView()
                        .environment(\.managedObjectContext, PersistentStore.shared.context)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: sectionDisplayButton)
                ToolbarItem(placement: .navigationBarTrailing, content: trailingButtons)
            }
            .onAppear {
                logAppear(title: "MainCatelogView")
                listDisplayID = UUID()
            }
            .onDisappear {
                logDisappear(title: "MainCatelogView")
                PersistentStore.shared.saveContext()
            }
    } // end of body: some View
    
    // MARK: - ToolbarItems
    
    // a "+" symbol to support adding a new item
    func addNewButton() -> some View {
    Button(action: { isAddNewItemSheetShowing = true })
        { Image(systemName: "plus")
            .font(.title2)
        }
    .sheet(isPresented: $isAddNewItemSheetShowing) {
        NavigationView {
            AddOrModifyItemView()
                .environment(\.managedObjectContext, PersistentStore.shared.context)
        }
    }
}
    
    // Sort Display Button
    func trailingButtons() -> some View {
    Button(action: { isAddNewItemSheetShowing = true })
        { Image(systemName: "plus")
            .font(.title2)
        }
}
    
    // a toggle button to change section display mechanisms
    func sectionDisplayButton() -> some View {
    Button() { multiSectionDisplay.toggle() }
        label: { Image(systemName: multiSectionDisplay ? "tray.2" : "tray")
                .font(.title2)
        }
    }
    
} // END OF STRUCT


struct AddICBView: View {
    
    @State var selected = 0
    
    var body: some View {
       
        VStack(spacing: 8){
            
            SegmentPicker(selected: self.$selected).padding(.top)
            
            if self.selected == 0 {
                AddOrModifyItemView()
            }
            else if self.selected == 1 {
                AddOrModifyBrandView()
            } else {
                AddOrModifyCategoryView()
            }
            
        }//.background(Color(.blue).edgesIgnoringSafeArea(.all))
    }
}

struct SegmentPicker: View {
    
    @Binding var selected: Int
    
    var body: some View {
        
        HStack{
            Button(action: {
                self.selected = 0
                }) {
                Text("Item")
                    .frame(width: 35, height: 1)
                    .padding(.vertical,12)
                    .padding(.horizontal,30)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 0 ? .green : .black)
            
            Button(action: {
                self.selected = 1
            }) {
                Text("Brand")
                .frame(width: 50, height: 1)
                .padding(.vertical,12)
                .padding(.horizontal,30)
                .background(self.selected == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 1 ? .green : .black)
            
            Button(action: {
                self.selected = 2
            }) {
                Text("Category")
                .frame(width: 70, height: 1)
                .padding(.vertical,12)
                .padding(.horizontal,30)
                .background(self.selected == 2 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 2 ? .green : .black)
            
            }
            .frame(height: 30)
            .padding(5)
            .background(Color.secondary.cornerRadius(10))
            //.clipShape(Capsule())
            .animation(.easeInOut)
    }
}



