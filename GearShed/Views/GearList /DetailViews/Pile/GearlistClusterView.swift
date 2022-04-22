//
//  GearlistPileView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
import SwiftUI

struct GearlistPileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @State private var confirmDeletePileAlert: ConfirmDeletePileAlert?
    
    @ObservedObject var gearlist: Gearlist
    
    var body: some View {
        VStack (spacing: 0) {
            StatBar(statType: .pile, gearlist: gearlist)
            ZStack {
                if gearlist.piles.count == 0 {
                    EmptyViewText(text: "You have not added any piles to this list. To add your first pile press the 'Add Pile' button below.")
                } else {
                    gearlistPileList
                }
                addPileButtonOverlay
            }
        }
        .alert(item: $confirmDeletePileAlert) { pile in pile.alert() }
    }
    
    private var gearlistPileList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(gearlist.piles) { pile in
                    Section {
                        listContent(pile: pile)
                    } header: {
                        listHeader(pile: pile)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private func listContent(pile: Pile) -> some View {
        ForEach(pile.items) { item in
            ItemRowView_InPile(pile: pile, item: item)
        }
    }
    
    private func listHeader(pile: Pile) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(pile.name)
                    .font(.headline)
                
                if (Prefs.shared.weightUnit == "g") {
                    Text("\(viewModel.pileTotalGrams(pile: pile))g")
                }
                if (Prefs.shared.weightUnit == "lb + oz") {
                    let LbOz = viewModel.pileTotalLbsOz(pile: pile)
                    let lbs = LbOz.lbs
                    let oz = LbOz.oz
                    Text("\(lbs) lbs \(oz) oz")
                }
                
                /*if (persistentStore.stateUnit == "g") {
                    Text("\(viewModel.pileTotalGrams(pile: pile))g")
                }
                
                if (persistentStore.stateUnit == "lb + oz") {
                    let LbOz = viewModel.pileTotalLbsOz(pile: pile)
                    let lbs = LbOz.lbs
                    let oz = LbOz.oz
                    Text("\(lbs) lbs \(oz) oz")
                }*/
                Spacer()
                Menu {
                    Button {
                        detailManager.selectedPile = pile
                        withAnimation {
                            detailManager.secondaryTarget = .showAddItemsToPile
                        }
                    } label: {
                        HStack {
                            Text("Add to Pile").textCase(.none)
                            Image(systemName: "plus")
                        }
                    }
                    Button {
                        detailManager.selectedPile = pile
                        withAnimation {
                            detailManager.secondaryTarget = .showModifyPile
                        }
                    } label: {
                        HStack {
                            Text("Edit Pile Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    Button {
                        confirmDeletePileAlert = ConfirmDeletePileAlert (
                            persistentStore: persistentStore,
                            pile: pile,
                            destructiveCompletion: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    } label: {
                        HStack {
                            Text("Delete Pile").textCase(.none)
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
    
    private var addPileButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.selectedGearlist = gearlist
                    withAnimation {
                        detailManager.secondaryTarget = .showAddPile
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Pile")
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


