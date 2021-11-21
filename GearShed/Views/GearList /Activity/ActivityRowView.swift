//
//  GearlistRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct ActivityRowView: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject var viewModel: GearlistData
    
    @EnvironmentObject var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var activity: Gearlist
    
    @State private var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    
    var body: some View {
        Button {
            detailManager.selectedGearlist = activity
            withAnimation {
                detailManager.showGearlistDetail = true
            }
        } label: {
            rowBody
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
        .alert(item: $confirmDeleteGearlistAlert) { activity in activity.alert() }
    }
}

extension ActivityRowView {
    
    private var rowBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                Text(activity.name)
                    .formatItemNameGreen()
                    .fixedSize()
                    .lineLimit(1)
                Text(activity.details)
                    .formatItemDetailsGrey()
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    private var editContextButton: some View {
        Button {
            withAnimation {
                detailManager.showModifyActivity = true
            }
        } label: {
            HStack {
                Text("Edit Activity")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteGearlistAlert = ConfirmDeleteGearlistAlert (
                persistentStore: persistentStore,
                gearlist: activity,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Activity")
                Image(systemName: "trash")
            }
        }
    }
}





