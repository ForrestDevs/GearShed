//
//  GearPlanView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import SwiftUI

struct GearPlanView: View {
    static let tag: String? = "GearShed"
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var currentSelection: Int = 0
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        PagerTabView(tint: Color.theme.accent,selection: $currentSelection) {
            HStack(spacing: 0) {
                Text("GENERIC LIST")
                    .pageLabel()
                    .font(.system(size: 12).bold())
                
                Text("LABELS")
                    .pageLabel()
                    .font(.system(size: 12).bold())
            }
        }
        content: {
            Text("Generic List")
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            Text("Labels")
                .pageView(ignoresSafeArea: true, edges: .bottom)

        }
        .padding(.top, 10)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("Gear Plan", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    //showPDFScreen.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

