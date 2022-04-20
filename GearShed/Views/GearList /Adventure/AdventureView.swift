//
//  AdventureView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//
import SwiftUI

struct AdventureView: View {
    @EnvironmentObject private var viewModel: GearlistData
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @State private var showUnlock: Bool = false
    
    var body: some View {
        ZStack {
            VStack (spacing: 0){
                StatBar(statType: .adventure)
                if viewModel.adventures.count == 0 {
                    EmptyViewText(text: "You have not created any adventures yet. To create your first adventure press the '+' button below.")
                } else {
                    adventureList
                }
            }
            addListButtonOverlay
        }
        .sheet(isPresented: $showUnlock) {
            UnlockView()
        }
    }
    
    private var adventureList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.sectionByYear(array: viewModel.adventures)) { section in
                    Section {
                        listContent(section: section)
                    } header: {
                        listHeader(section: section)
                    }
                }
            }
        }
    }
    
    private var addListButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    detailManager.target = .noView
                    if viewModel.verifyUnlimitedGearlists() {
                        withAnimation {
                            detailManager.target = .showAddAdventure
                        }
                    } else {
                        self.showUnlock = true
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
        .padding(.bottom, 30)

        
    }
    
    private func listContent(section: SectionYearData) -> some View {
        ForEach(section.adventures) { adventure in
            AdventureRowView(adventure: adventure)
        }
    }
    
    private func listHeader(section: SectionYearData) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(section.title).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
}

