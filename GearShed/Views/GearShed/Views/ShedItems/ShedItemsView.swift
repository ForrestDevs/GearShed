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
    @EnvironmentObject private var gsvm: GearShedViewModel
    
    @StateObject private var vm = ShedItemsViewModel()

    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .shed)
                if gsData.sheds.count == 0 {
                    EmptyViewText(emptyText: "Shed", buttonName: "Add Shed")
                } else {
                    listView
                }
            }
            
            // Invisible Rects for seperate alerts
            Rectangle()
                .opacity(0)
                .alert(item: $vm.confirmDeleteShedAlert) { shed in shed.alert() }
            
            Rectangle()
                .opacity(0)
                .alert(item: $gsvm.confirmDeleteItemAlert) { item in item.alert() }
            
           
            ExpandableButton(type: .shed)
                .environmentObject(detailManager)
                .environmentObject(vm)
                .environmentObject(gsData)
        }
        .sheet(isPresented: $vm.showingUnlockView) {
            UnlockView()
        }
        
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach (gsData.sheds) { shed in
                    Section {
                        sectionContent(shed: shed)
                    } header: {
                        sectionHeader(shed: shed)
                    }
                }
            }
            .padding(.bottom, 150)
        }
    }
    
    private func sectionContent(shed: Shed) -> some View {
        ForEach (shed.items) { item in
            if gsData.showAll {
                ItemRowView(item: item)
                    .padding(.leading, 15)
            }
        }
    }
    
    private func sectionHeader(shed: Shed) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            
            HStack {
                Text(shed.name).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                
                Spacer()
                
                Menu {
                    Button {
                        if gsData.proUser() {
                            detailManager.selectedShed = shed
                            withAnimation {
                                detailManager.target = .showAddItemFromShed
                            }
                        } else {
                            vm.showingUnlockView.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Add Gear to Shed").textCase(.none)
                            Image(systemName: "plus")
                        }
                    }
                    Button {
                        detailManager.selectedShed = shed
                        withAnimation {
                            detailManager.target = .showModifyShed
                        }
                    } label: {
                        HStack {
                            Text("Edit Shed Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    Button {
                        vm.confirmDeleteShedAlert = ConfirmDeleteShedAlert (
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
            .padding(.horizontal, 15)
        }
    }
}
