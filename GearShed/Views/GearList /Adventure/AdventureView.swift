//
//  TripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import SwiftUI

struct TripView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    var body: some View {
        ZStack {
            VStack (spacing: 0){
                StatBar(statType: .adventure)
                tripsList
            }
            //.padding(.top, 5)
            addListButtonOverlay
        }
        
    }
}

extension TripView {
    
    private var tripsList: some View {
        List {
            ForEach(viewModel.sectionByYear(array: viewModel.trips)) { section in
                Section {
                    ForEach(section.adventures) { adventure in
                        AdventureRowView(adventure: adventure)
                    }
                } header: {
                    Text(section.title)
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var addListButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        detailManager.showAddAdventure = true
                    }
                }
                label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 40)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
        .padding(.bottom, 50)

        
    }
}
