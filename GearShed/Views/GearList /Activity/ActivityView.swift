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
    
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                StatBar(statType: .activity)
                activitiesList
            }
            addListButtonOverlay
        }
        .alert(item: $confirmDeleteActivityTypeAlert) { type in type.alert() }
    }
}

extension ActivityView {

    private var activitiesList: some View {
        List {
            ForEach(viewModel.activityTypes) { type in
                Section {
                    ForEach(type.gearlists) { activity in
                        GearlistRowView(gearlist: activity)
                    }
                } header: {
                    HStack {
                        Text(type.name)
                        Menu {
                            Button {
                                detailManager.selectedActivityType = type
                                withAnimation {
                                    detailManager.showAddActivityFromActivityType = true
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
                                    detailManager.showModifyActivityType = true
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
                            HStack {
                                Spacer()
                                Image(systemName: "square.and.pencil")
                            }
                            
                        }
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
                    withAnimation {
                        detailManager.showAddActivity = true
                    }
                }
                label: {
                    VStack{
                        Text("Create")
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




