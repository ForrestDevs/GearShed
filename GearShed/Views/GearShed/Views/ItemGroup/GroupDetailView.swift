//
//  GroupDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import SwiftUI

struct GroupDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @ObservedObject var group: ItemGroup
    
    @State private var isEditGroupShowing: Bool = false
    
    init(persistentStore: PersistentStore, group: ItemGroup) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.group = group
    }
    
    var body: some View {
        
        VStack{
            Text("")
        }
        /*NavigationView {
            VStack(spacing:0) {
                statBar
                itemList
            }
            .navigationBarTitle(group.name, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isEditGroupShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .fullScreenCover(isPresented: $isEditGroupShowing) {
                ModifyShedView(group: group).environment(\.managedObjectContext, PersistentStore.shared.context)
            }
        }*/
    }
}
