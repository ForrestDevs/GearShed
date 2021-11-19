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
            addListButtonOverlay
        }
        
    }
}

extension TripView {
    
    private var tripsList: some View {
        VStack {
            List {
                ForEach(viewModel.sectionByYear(array: viewModel.trips)) { section in
                    Section {
                        ForEach(section.adventures) { adventure in
                            TripRowView(trip: adventure)
                        }
                    } header: {
                        Text(section.title)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
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
                .padding(.bottom, 40)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
        
    }
}
