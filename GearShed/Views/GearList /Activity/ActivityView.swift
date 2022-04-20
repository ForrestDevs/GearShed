//
//  ActivityView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//
import SwiftUI

struct ActivityView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var confirmDeleteActivityTypeAlert: ConfirmDeleteActivityTypeAlert?
    @State private var showUnlock: Bool = false
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .activity)
                if viewModel.activities.count == 0 {
                    EmptyViewText(text: "You have not created any activities yet. To create your first actvity  press the '+' button below.")
                } else {
                    activitiesList
                }
            }
            addListButtonOverlay
        }
        .alert(item: $confirmDeleteActivityTypeAlert) { type in type.alert() }
        .sheet(isPresented: $showUnlock) {
            UnlockView()
        }
    }
    
    private var activitiesList: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.activityTypes) { type in
                    Section {
                        listContent(type: type)
                    } header: {
                        listHeader(type: type)
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
                            detailManager.target = .showAddActivity
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
    
    private func listContent(type: ActivityType) -> some View {
        ForEach(type.gearlists) { activity in
            ActivityRowView(activity: activity)
        }
    }
    
    private func listHeader(type: ActivityType) -> some View {
        ZStack {
            Color.theme.headerBG
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Text(type.name).textCase(.none)
                    .font(.custom("HelveticaNeue", size: 16.5).bold())
                Spacer()
                Menu {
                    Button {
                        detailManager.selectedActivityType = type
                        withAnimation {
                            detailManager.target = .showAddActivityFromActivityType
                        }
                    } label: {
                        HStack {
                            Text("Add to " + "\(type.name)").textCase(.none)
                            Image(systemName: "plus")
                        }
                        
                    }
                    Button {
                        detailManager.selectedActivityType = type
                        withAnimation {
                            detailManager.target = .showModifyActivityType
                        }
                    } label: {
                        HStack {
                            Text("Edit \(type.name) Name").textCase(.none)
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    Button {
                        confirmDeleteActivityTypeAlert = ConfirmDeleteActivityTypeAlert (
                            persistentStore: persistentStore,
                            type: type,
                            destructiveCompletion: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    } label: {
                        HStack {
                            Text("Delete \(type.name)").textCase(.none)
                            Image(systemName: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            .padding(.horizontal, 15)
        }
    }
}




