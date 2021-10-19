//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct MainCatelogView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @State var displayBy = 1
    
    @State private var selected = 1

    static let tag: String? = "MainCatelog"
    
    var body: some View {
            VStack(spacing: 5) {
                
                SPForShedView(selected: $selected)
                   
                if self.selected == 0 {
                    AllItemsView()
                } else if self.selected == 1 {
                    AllCategoryView()
                }
                else if self.selected == 2 {
                    AllBrandView()
                } else if self.selected == 3 {
                    AllTagView()
                } else {
                    AllWishListView()
                }
                
                
                
                Spacer()
                
                
            } // end of VStack
            .navigationBarTitle("My Shed", displayMode: .inline)
            .fullScreenCover(isPresented: $viewModel.isAddNewItemSheetShowing){AddOrModifyItemView().environment(\.managedObjectContext, PersistentStore.shared.context)}
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: viewModel.leadingButton)
                ToolbarItem(placement: .navigationBarTrailing, content: viewModel.trailingButtons)
            }
            .onAppear {
                logAppear(title: "MainCatelogView")
            }
            .onDisappear {
                logDisappear(title: "MainCatelogView")
                PersistentStore.shared.saveContext()
            }
        
        
    }
    
    
} // END OF STRUCT

struct SPForShedView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button { self.selected = 0}
                    label: { Text("ITEM")
                        //.fontWeight(self.selected == 0 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 0 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 0 ? .white : .black)
                
                Button { self.selected = 1}
                    label: { Text("CATEGORY")
                        //.fontWeight(self.selected == 1 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 1 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 1 ? .white : .black)
                
                Button { self.selected = 2 }
                    label: { Text("BRAND")
                        //.fontWeight(self.selected == 2 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 2 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 2 ? .white : .black)
                
                Button { self.selected = 3}
                    label: { Text("TAG")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 3 ? .white : .black)
                
                Button { self.selected = 4}
                    label: { Text("WISHLIST")
                        //.fontWeight(self.selected == 4 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.fontWeight(self.selected == 4 ? .bold : .body)
                                //.background(self.selected == 4 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 4 ? .white : .black)
            }
        }
        .padding(.vertical, 10)
        .background(Color.theme.green)
        .animation(.easeInOut)
        
    }
}

// MARK: CustomPopOverz

struct PopOverView: View {
    
    @State var graphicalDate: Bool = false
    @State var showPicker: Bool = false
    
    @State var show: Bool = false
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
    
    @State private var selectedColor = "Red"
    
    var body: some View {
        
        NavigationView{
            
            List {
                
                Toggle(isOn: $showPicker) {
                    Text("Show Picker")
                }
                
                Toggle(isOn: $graphicalDate) {
                    Text("Show Graphical Data Picker")
                }
            }
            .navigationTitle("Popovers")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            show.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square")
                    }
                }
            }
            
        }
        .toolBarPopover(show: $show, placement: .leading) {
            Picker("Please choose a color", selection: $selectedColor) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

extension View {
    
    func toolBarPopover<Content: View>(show: Binding<Bool>,placement: Placement = .leading ,@ViewBuilder content: @escaping ()->Content)->some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
            
                ZStack {
                    if show.wrappedValue {
                        content()
                            .padding()
                            .background(Color.white.clipShape(PopOverArrowShape(placement: placement)))
                            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.primary.opacity(0.05), radius: 5, x: -5, y: -5)
                            .padding(.horizontal, 35)
                            // Moving from top...
                            // Approx NavBar Height....
                            .offset(y: 25)
                            .offset(x: placement == .leading ? -20 : 20)
                        
                    }
                }, alignment: placement == .leading ? .topLeading : .topTrailing
            )
    }
}

enum Placement{
    case leading
    case trailing
}

struct PopOverArrowShape: Shape {
    
    var placement: Placement
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
        
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: 50, y: 50)
            let pt3 = CGPoint(x: rect.width, y: rect.height)
            let pt4 = CGPoint(x: 0, y: rect.height)
        
            // Drawing Arcs with raduis..
            path.move(to: pt4)
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 15)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 15)
            
            //Arrow...
            path.move(to: pt1)
            path.addLine(to: CGPoint(x: placement == .leading ? 10 : rect.width - 10, y: 0))
            path.addLine(to: CGPoint(x: placement == .leading ? 15 : rect.width - 15, y: 0))
            path.addLine(to: CGPoint(x: placement == .leading ? 25 : rect.width - 25, y: -15))
            path.addLine(to: CGPoint(x: placement == .leading ? 40 : rect.width - 40, y: 0))
        }
    }
}

/*struct Temp: View {
    
    var body: some View {
        //SearchBarView1(searchText: $viewModel.searchText)
        Rectangle()
        .frame(width: 0.01 ,height: 0.01)
        .actionSheet(isPresented: $viewModel.showDisplayAction) {
            ActionSheet(title: Text("Display:"), buttons: [
                .default(Text("All Items")) {displayBy = 0},
                .default(Text("Grouped by Category")) {displayBy = 1},
                .default(Text("Grouped by Brand")) {displayBy = 2}
            ])
        }
            .padding(.bottom, 10)
        
        if viewModel.itemsInCatelog.count == 0 {
            EmptyCatelogView()
        } else {
            ItemListDisplay(displayBy: $displayBy)
        }

        Rectangle()
            .frame(height: 1)
            .padding(.top, 5)
        
        Spacer(minLength: 80)
    }
    
    
}*/



