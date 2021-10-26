//
//  ShedDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct ShedDetailView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @ObservedObject var shed: Shed
    @State private var isEditShedShowing: Bool = false

    var body: some View {
        VStack(spacing:0) {
            
            StatBarInShed(persistentStore: persistentStore, shed: shed)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(shed.items) { item in
                    ItemRowView(item: item)
                }
            }
            //.padding(.top, 20)
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 60)
                
        }
        .navigationTitle(shed.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { isEditShedShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
            }
        }
        .fullScreenCover(isPresented: $isEditShedShowing) {
            ModifyShedView(shed: shed).environment(\.managedObjectContext, PersistentStore.shared.context)
        }
    }
}





