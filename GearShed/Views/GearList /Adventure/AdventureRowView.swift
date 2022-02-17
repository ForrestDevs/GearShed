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
                detailManager.target = .showGearlistDetail
            }
        } label: {
            rowBody
        }
        .contextMenu {
            bucketListContextMenu
            editContextButton
            duplicateContextButton
            deleteContextButton
        }
        .alert(item: $confirmDeleteGearlistAlert) { adventure in adventure.alert() }
    }
    
    // MARK: Main Content
    
    private var bucketlistStatus: some View {
        VStack {
            if adventure.isBucketlist {
                Image("flag3")
                    .resizable()
                    .interpolation(.high)
                    //.foregroundColor(Color.red)
                    .frame(width: 14, height: 14)
                    .padding(.horizontal, 2)
            }
        }
    }
    
    private var rowBody: some View {
        VStack (alignment: .leading, spacing: 2) {
            HStack {
                HStack (spacing: 5) {
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
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Divider()
        }
        .padding(.leading, 15)
        .padding(.bottom, 4)
    
    }
    
    // MARK: Context Menus
    private var editContextButton: some View {
        Button {
            detailManager.selectedGearlist = adventure
            withAnimation {
                detailManager.target = .showModifyAdventure
            }
        } label: {
            HStack {
                Text("Edit Adventure")
                Image(systemName: "square.and.pencil")
            }
        }
    }
    
    private var duplicateContextButton: some View {
        Button {
            viewModel.duplicateGearlist(gearlist: adventure)
        } label: {
            HStack {
                Text("Duplicate Gearlist")
                Image(systemName: "doc.on.doc.fill")
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
                Image("flag3")
            }
        }
    }
}

