//
//  TripsTabView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct GearlistView: View {
    static let tag: String? = "GearList"
    
    let persistentStore: PersistentStore
        
    @StateObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
     
    @State private var viewFilter: ViewFilter = .multiDay
    
    private enum ViewFilter {
        case all, singleDay, multiDay, noDay
    }
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        
        let viewModel = GearlistData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                content
                addButtonOverlay
            }
        }
        .environmentObject(viewModel)
        .navigationBarTitle("Gear List", displayMode: .inline)
        .toolbar {
            filterButton
            shareList
        }
        .onDisappear() {
            persistentStore.saveContext()
        }
    }
}

extension GearlistView {
    
    private var shareList: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {} label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
    
    private var filterButton: some ToolbarContent {
        ToolbarItem (placement: .navigationBarLeading) {
            Menu {
                Button {
                    viewFilter = .all
                } label: {
                    Text("All")
                }
                
                Button {
                    viewFilter = .singleDay
                } label: {
                    Text("Single-Day")
                }
                
                Button {
                    viewFilter = .multiDay
                } label: {
                    Text("Multi-Day")
                }
                
                Button {
                    viewFilter = .noDay
                } label: {
                    Text("No-Date")
                }
            } label: {
                Image(systemName: "text.magnifyingglass")
            }
        }
        
    }
    
    private var searchBar: some View {
        VStack {
            
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                //Text("\(gsData.items.count)")
            }
            HStack {
                Text("Weight:")
                //Text("\(gsData.totalWeight(array: gsData.items))g")
            }
            HStack {
                Text("Invested:")
                //Text("$\(gsData.totalCost(array: gsData.items))")
            }
            Spacer()
        }
        .font(.custom("HelveticaNeue", size: 14))
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
    }
    
    private var content: some View {
        VStack {
            if viewFilter == .all {
                TripView()
            } else if viewFilter == .singleDay {
                TripView()
            } else if viewFilter == .multiDay {
                TripView()
            } else if viewFilter == .noDay {
                ActivityView()
            }
        }
    }
    
    private var addButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        detailManager.showAddGearlist = true
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("List")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
}


//@State private var currentScreen: Int = 0

/*PagerTabView(tint: Color.theme.accent, selection: $currentScreen) {
    Text("Activity")
        .pageLabel()
        .font(.system(size: 12).bold())

    Text("Trip")
        .pageLabel()
        .font(.system(size: 12).bold())
} content: {
    ActivityView()
    .pageView(ignoresSafeArea: true, edges: .bottom)
    TripView()
    .pageView(ignoresSafeArea: true, edges: .bottom)
}*/

//@State private var currentSelection: Int = 0

/*PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
    Text("PERSONAL LIST")
        .pageLabel()
        .font(.system(size: 12).bold())
    Text("GENARIC LIST")
        .pageLabel()
        .font(.system(size: 12).bold())
} content: {
    AllGearLists(persistentStore: persistentStore)
        .pageView(ignoresSafeArea: true, edges: .bottom)
        
    EmptyTripView()
        .pageView(ignoresSafeArea: true, edges: .bottom)
}*/

/*
struct Home : View {
    
    @State var show = false
    @State var txt = ""
    @State var data = ["p1","p2","p3","p4","p5","p6"]
    
    var body : some View{
        
        VStack(spacing: 0){
            
            HStack{
                
                if !self.show{
                    
                     Text("Food")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if self.show{
                        
                        Image("search").padding(.horizontal, 8)
                        
                        TextField("Search Food", text: self.$txt)
                        
                        Button(action: {
                            
                            withAnimation {
                                
                                self.txt = ""
                                self.show.toggle()
                            }
                            
                        }) {
                            
                            Image(systemName: "xmark").foregroundColor(.black)
                        }
                        .padding(.horizontal, 8)
                        
                    }
                    
                    else{
                        
                        Button(action: {
                            
                            withAnimation {
                                
                                self.show.toggle()
                            }
                            
                        }) {
                            
                            Image("search").foregroundColor(.black).padding(10)
                            
                        }
                    }
                }
                .padding(self.show ? 10 : 0)
                .background(Color.white)
                .cornerRadius(20)
                
                
            }
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(Color.orange)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    if self.txt != ""{
                        
                        if data.filter({$0.lowercased().contains(self.txt.lowercased())}).count == 0{
                            
                            Text("No Results Found").padding(.top, 10)
                        }
                        else{
                            
                            ForEach(data.filter({$0.lowercased().contains(self.txt.lowercased())}),id: \.self){i in
                                
                                cellView(image: i)
                            }
                        }
                    }
                    
                    else{
                        
                        ForEach(data,id: \.self){i in
                            
                            cellView(image: i)
                        }
                    }

                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct cellView : View {
    
    var image : String
    
    var body : some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(image).resizable().frame(height: 200).cornerRadius(20)
            
            Button(action: {
                
            }) {
                
                Image(systemName: "arrow.right").foregroundColor(.black).padding()
            }
            .background(Color.white)
            .clipShape(Circle())
            .padding()
            
        }
    }
}

class Host: UIHostingController<ContentView> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}
*/


