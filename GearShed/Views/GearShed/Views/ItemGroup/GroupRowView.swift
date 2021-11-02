//
//  GroupRowView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import SwiftUI

struct GroupRowView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    
    @ObservedObject var group: ItemGroup
    
    @State private var showDetail: Bool = false

    var body: some View {
        VStack {
            Button {
                showDetail.toggle()
            } label: {
                HStack {
                    Text(group.name)
                        .font(.headline)
                    Spacer()
                    Text("\(group.sheds.count)")
                        .font(.headline)
                }
            }
        }
        .fullScreenCover(isPresented: $showDetail) {
            GroupDetailView(persistentStore: persistentStore, group: group)
        }
    }
}

