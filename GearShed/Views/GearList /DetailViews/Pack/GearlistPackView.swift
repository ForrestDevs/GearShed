//
//  GearlistPackView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct GearlistPackView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var viewModel: GearlistData
    @ObservedObject var gearlist: Gearlist
    @State private var confirmDeletePackAlert: ConfirmDeletePackAlert?
    
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .pack, gearlist: gearlist)
            ZStack {
                if gearlist.packs.count == 0 {
                    EmptyViewText(text: "You have not added any packs to this list. To add your first pack press the 'Add Pack' button below.")
                } else {
                    packingPackList
                }
                addPackButtonOverlay
            }
        }
        .alert(item: $confirmDeletePackAlert) { container in container.alert() }
    }
    //MARK: Main Content
    private var packingPackList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(gearlist.packs) { container in
                    Section {
                        listContent(container: container)
                    } header: {
                        listHeader(container: container)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    private func listHeader(container: Pack) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(container.name)
                    .font(.headline)
                if (Prefs.shared.weightUnit == "g") {
                    Text("\(viewModel.packTotalGrams(pack: container))g")
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    let LbOz = viewModel.packTotalLbsOz(pack: container)
                    let lbs = LbOz.lbs
                    let oz = LbOz.oz
                    Text("\(lbs) lbs \(oz) oz")
                }
                Spacer()
                Menu {
                    Button {
                        detailManager.selectedPack = container
                        withAnimation {
                            detailManager.secondaryTarget = .showAddItemsToPack
                        }
                    } label: {
                        HStack {
                            Text("Add Gear to Pack").textCase(.none)
                            Image(systemName: "plus")
                        }
                    }
                    Button {
                        detailManager.selectedPack = container
                        withAnimation {
                            detailManager.secondaryTarget = .showModifyPack
                        }
                    } label: {
                        HStack {
                            Text("Edit Pack Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    Button {
                        confirmDeletePackAlert = ConfirmDeletePackAlert (
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
            .padding(.horizontal, 15)
        }
    }
    private func listContent(container: Pack) -> some View {
        ForEach(container.items) { item in
            ItemRowViewInPack(item: item, gearlist: gearlist, container: container)
        }
    }
    private var addPackButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddPack
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
}

