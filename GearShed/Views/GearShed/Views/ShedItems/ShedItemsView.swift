//
//  ShedItemsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ShedItemsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var gsData: GearShedData
    
    @StateObject private var vm = ShedItemsViewModel()
    
    @State private var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
    
    @State private var searchText: String = ""

    var body: some View {
        
        ZStack {
            VStack {
                List {
                    ForEach(gsData.sheds) { shed in
                        Section {
                            ForEach(shed.items) { item in
                                ItemRowView(item: item)
                            }
                        } header: {
                            HStack {
                                Text(shed.name).textCase(.none)
                                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                                
                                Spacer()
                                
                                Menu {
                                    Button {
                                        let canCreate = self.persistentStore.fullVersionUnlocked ||
                                        self.persistentStore.count(for: Item.fetchRequest()) < 3
                                        if canCreate {
                                            detailManager.selectedShed = shed
                                            withAnimation {
                                                detailManager.showAddItemFromShed = true
                                            }
                                        } else {
                                            vm.showingUnlockView.toggle()
                                        }
                                    } label: {
                                        HStack {
                                            Text("Add to Shed").textCase(.none)
                                            Image(systemName: "plus")
                                        }
                                        
                                    }
                                    Button {
                                        detailManager.selectedShed = shed
                                        withAnimation {
                                            detailManager.showModifyShed = true
                                        }
                                    } label: {
                                        HStack {
                                            Text("Edit Shed Name").textCase(.none)
                                            Image(systemName: "square.and.pencil")
                                        }
                                    }
                                    Button {
                                        confirmDeleteShedAlert = ConfirmDeleteShedAlert (
                                            persistentStore: persistentStore,
                                            shed: shed,
                                            destructiveCompletion: {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        )
                                    } label: {
                                        HStack {
                                            Text("Delete Shed").textCase(.none)
                                            Image(systemName: "trash")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .padding(.horizontal, 2)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            ExpandableButton()
                .environmentObject(detailManager)
        }
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
        .alert(item: $confirmDeleteShedAlert) { shed in shed.alert() }
    }
    
}
/*
struct CustomHeader: View {
    let name: String
    let color: Color

    var body: some View {
        VStack {
            Text(name)
        }
        .padding(0).background(FillAll(color: color))
    }
}

struct FillAll: View {
    let color: Color
    
    var body: some View {
        GeometryReader { proxy in
            self.color.frame(width: proxy.size.width * 1.3).fixedSize()
        }
    }
}


struct PopOverButton: View {
    
    let shed: Shed
    let detailManager: DetailViewManager
    
    @State private var showPopover: Bool = false
    
    var body: some View {
        
        Button {
            detailManager.selectedShed = shed
            showPopover.toggle()
        } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: 17, height: 17)
                .padding(.horizontal, 2)
        }
        .overlay ( showPopover ?
            ( PopOverMenu()
                .background(Color.white)
                .cornerRadius(15)
                .clipShape(ArrowShape())
                .offset(y: -120)
                
            ) : nil
        )
        
    }
}
struct PopOverMenu: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            Button {
                
            } label: {
                HStack (spacing: 15){
                    Image(systemName: "house")
                        .renderingMode(.original)
                    Text("Home")
                }
            }
            Divider()
            
            Button {
                
            } label: {
                HStack (spacing: 15){
                    Image(systemName: "house")
                        .renderingMode(.original)
                    Text("Home")
                }
            }
            Divider()
            
            Button {
                
            } label: {
                HStack (spacing: 15){
                    Image(systemName: "house")
                        .renderingMode(.original)
                    Text("Home")
                }
            }
        }
        .foregroundColor(Color.black)
        .frame(width: 140)
        .padding()
        .padding(.bottom, 20)
        .background(Color.white)
    }
    
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = rect.width / 2
        return Path { path in
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center - 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center, y: rect.height - 5))
            path.addLine(to: CGPoint(x: center + 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
        }
    }
}


*/










