//
//  TripRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//

import SwiftUI

struct AdventureRowView: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject var viewModel: GearlistData
    
    @EnvironmentObject var detailManager: DetailViewManager
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var adventure: Gearlist
    
    @State private var confirmDeleteGearlistAlert: ConfirmDeleteGearlistAlert?
    
    var body: some View {
        Button {
            detailManager.selectedGearlist = adventure
            withAnimation {
                detailManager.showGearlistDetail = true
            }
        } label: {
            rowBody
        }
        .contextMenu {
            bucketListContextMenu
            editContextButton
            deleteContextButton
        }
        .alert(item: $confirmDeleteGearlistAlert) { adventure in adventure.alert() }
    }
}

extension AdventureRowView {
    
    private var bucketlistStatus: some View {
        VStack {
            if adventure.isBucketlist {
                Image(systemName: "mappin")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
    
    private var rowBody: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                HStack {
                    HStack (spacing: 2) {
                        Text(adventure.name)
                            .formatItemNameGreen()
                            .fixedSize()
                        bucketlistStatus
                    }
                    Text("|")
                        .formatItemNameBlack()
                    Text(adventure.startDate?.dateText(style: .medium) ?? "")
                        .formatItemNameBlack()
                }
                .lineLimit(1)
                
                HStack {
                    Text(adventure.location ?? "")
                        .formatItemWeightBlack()
                    Text("|")
                        .formatItemWeightBlack()
                    Text(adventure.country ?? "")
                        .formatItemPriceGreen()
                }
                
                Text(adventure.details)
                    .formatItemDetailsGrey()
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.leading, 15)

    }
    
    private var editContextButton: some View {
        Button {
            detailManager.selectedGearlist = adventure
            withAnimation {
                detailManager.showModifyAdventure = true
            }
        } label: {
            HStack {
                Text("Edit Adventure")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteGearlistAlert = ConfirmDeleteGearlistAlert (
                persistentStore: persistentStore,
                gearlist: adventure,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            HStack {
                Text("Delete Adventure")
                Image(systemName: "trash")
            }
        }
    }
    
    private var bucketListContextMenu: some View {
        Button {
            viewModel.toggleBucketlist(gearlist: adventure)
        } label: {
            HStack {
                if adventure.isBucketlist {
                    Text("Unmark Bucketlist")
                } else {
                    Text("Mark Bucketlist")
                }
                Image(systemName: "mappin")
            }
        }
    }
}

