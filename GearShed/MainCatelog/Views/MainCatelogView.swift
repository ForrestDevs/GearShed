//
//  MainCatelogView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct MainCatelogView: View {
    
    @StateObject private var viewModel = MainCatelogVM()
    
    @State private var dragOffset = CGSize.zero
    
    @State var displayBy = 1
    
    @State private var selected = 1

    //static let tag: String? = "MainCatelog"
    
    var body: some View {
            VStack(spacing: 5) {
                
                SPForShedView(selected: $selected)
                   
                if self.selected == 1 {
                    AllCategoryView()
                        .transition(.moveAndFade)
                        .offset(dragOffset)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    dragOffset = gesture.translation
                                                }
                                                .onEnded { gesture in
                                                    dragOffset = .zero
                                                }
                                        )
                }
                else if self.selected == 2 {
                    AllBrandView()
                        .transition(.moveAndFade)
                        .offset(dragOffset)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    dragOffset = gesture.translation
                                                }
                                                .onEnded { gesture in
                                                    dragOffset = .zero
                                                }
                                        )
                } else if self.selected == 3 {
                    AllFavouriteView()
                        .transition(.moveAndFade)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = gesture.translation
                                }
                                .onEnded { gesture in
                                    dragOffset = .zero
                                }
                        )
                } else {
                    AllWishListView()
                        .transition(.moveAndFade)
                        .offset(dragOffset)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    dragOffset = gesture.translation
                                                }
                                                .onEnded { gesture in
                                                    dragOffset = .zero
                                                }
                                        )
                }
                
                
                
                Spacer()
                
                
            } // end of VStack
            .navigationBarTitle("Gear Shed", displayMode: .inline)
            .fullScreenCover(isPresented: $viewModel.isAddNewItemShowing){AddItemView().environment(\.managedObjectContext, PersistentStore.shared.context)}
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
                
                //Button { self.selected = 0}
                //    label: { Text("ITEM")
                //        //.fontWeight(self.selected == 0 ? .bold : .regular)
                //                //.padding(.vertical,12)
                //                .padding(.horizontal,10)
                //                //.background(self.selected == 0 ? Color.white : Color.clear)
                //}
                //.foregroundColor(self.selected == 0 ? .white : .black)
                
                Button {
                    withAnimation {
                        self.selected = 1
                    }
                }
                    label: { Text("SHED")
                        //.fontWeight(self.selected == 1 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 1 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 1 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 2
                } }
                    label: { Text("BRAND")
                        //.fontWeight(self.selected == 2 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 2 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 2 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 3
                }}
                    label: { Text("FAVOURITE")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 3 ? .white : .black)
                
                Button {withAnimation {
                    self.selected = 4
                }}
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







