//
//  GearlistContainerView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct GearlistContainerView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var confirmDeleteContainerAlert: ConfirmDeleteContainerAlert?
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                if gearlist.containers.count == 0 {
                    EmptyViewText(emptyText: "Packs", buttonName: "Add Pack")
                } else {
                    packingContainerList
                }
                
                addContainerButtonOverlay
            }
        }
        .alert(item: $confirmDeleteContainerAlert) { container in container.alert() }
    }

}

extension GearlistContainerView {
    
    private var packingContainerList: some View {
        VStack {
            List {
                ForEach(gearlist.containers) { container in
                    Section {
                        ForEach(container.items) { item in
                            ItemRowView_InContainer(item: item, gearlist: gearlist, container: container)
                        }
                    } header: {
                        HStack {
                            HStack {
                                Text(container.name)
                                    .font(.headline)
                                Text("\(viewModel.containerTotalWeight(container: container))g")
                                Spacer()
                                Menu {
                                    Button {
                                        detailManager.selectedContainer = container
                                        withAnimation {
                                            detailManager.showModifyContainer = true
                                        }
                                    } label: {
                                        HStack {
                                            Text("Edit Pack Name").textCase(.none)
                                            Image(systemName: "square.and.pencil")
                                        }
                                    }
                                    
                                    Button {
                                        confirmDeleteContainerAlert = ConfirmDeleteContainerAlert (
                                            persistentStore: persistentStore,
                                            container: container,
                                            destructiveCompletion: {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        )
                                    } label: {
                                        HStack {
                                            Text("Delete Pack").textCase(.none)
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
            }
            .listStyle(.insetGrouped)
        }
        
    }
    
    private var addContainerButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        detailManager.showAddContainer = true
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Pack")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
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
    
    private var statBar: some View {
        HStack (spacing: 20){
            
            Text (
                "Packed: " +
                "\(viewModel.gearlistContainerBoolTotals(gearlist: gearlist))" +
                " of " +
                "\(viewModel.gearlistContainerTotalItems(gearlist: gearlist))"
            )
            
            Text (
                "Weight: " +
                "\(viewModel.gearlistContainerTotalWeight(gearlist: gearlist))" +
                "g"
            )
            
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
}

/* Text("Packed:")
 Text("\(viewModel.gearlistContainerBoolTotals(gearlist: gearlist))")
 Text("of")
 Text("\(gearlist.gearlistContainerTotals(gearlist: gearlist))")*/

