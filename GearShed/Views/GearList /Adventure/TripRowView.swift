//
//  TripRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//

import SwiftUI

struct TripRowView: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject var viewModel: GearlistData
    
    @EnvironmentObject var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var trip: Gearlist
    
    @State private var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    @State private var showDetail: Bool = false
    @State private var showEdit: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
            VStack {
                Button {
                    detailManager.selectedGearlist = trip
                    withAnimation {
                        detailManager.showGearlistDetail = true
                    }
                } label: {
                    rowBody
                }
            }
            .padding(.horizontal, 20)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .fullScreenCover(isPresented: $showEdit) {
            ModifyListView(persistentStore: persistentStore, gearlist: trip)
        }
        .alert(item: $confirmDeleteGearlistAlert) { trip in trip.alert() }
    }
}

extension TripRowView {
    
    private var rowBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                HStack {
                    Text(trip.startDate.dateText(style: .medium))
                        .foregroundColor(.theme.green)
                    Text(trip.name)
                        .bold()
                }
                HStack {
                    Text(trip.location)
                    Text(trip.details)
                }
                .padding(.horizontal, 10)
            }
            Spacer()
        }
    }
    
    private var editContextButton: some View {
        Button {
            detailManager.selectedGearlist = trip
            withAnimation {
                detailManager.showModifyGearlist = true
            }
        } label: {
            HStack {
                Text("Edit List")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteGearlistAlert = ConfirmDeleteGearlistAlert (
                persistentStore: persistentStore,
                gearlist: trip,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete List")
                Image(systemName: "trash")
            }
        }
    }
}

