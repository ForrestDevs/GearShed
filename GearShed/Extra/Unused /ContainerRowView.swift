//
//  ContainerRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//
/*
import SwiftUI

struct ContainerRowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var container: Container
    
    @ObservedObject var gearlist: Gearlist
    
    @State private var showEdit: Bool = false
    
    @State private var confirmDeleteContainerAlert: ConfirmDeleteContainerAlert?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            containerHeader
                .padding(.horizontal)
            containerItems
        }
        .fullScreenCover(isPresented: $showEdit) {
            EditContainerView(persistentStore: persistentStore, container: container)
        }
        .alert(item: $confirmDeleteContainerAlert) { container in container.alert() }
    }
}

extension ContainerRowView {
    
    private var containerHeader: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text(container.name)
                    .font(.headline)
                Spacer()
                Text("\(viewModel.containerTotalWeight(container: container))g")
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
        .contextMenu {
            editContextButton
            deleteContextButton
        }
    }
    
    private var containerItems: some View {
        ForEach(container.items) { item in
            ItemRowView_InContainer(item: item, gearlist: gearlist, container: container)
        }
        .padding(.horizontal)
        .padding(.top, 7)
    }
    
    private var editContextButton: some View {
        Button {
            showEdit.toggle()
        } label: {
            Text("Edit Container")
        }
    }
    
    private var deleteContextButton: some View {
        Button {
            confirmDeleteContainerAlert = ConfirmDeleteContainerAlert (
                persistentStore: persistentStore,
                container: container,
                destructiveCompletion: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        } label: {
            Text("Delete Container")
        }
    }
}
*/
