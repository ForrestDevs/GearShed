//
//  AllGroupView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import SwiftUI

struct AllGroupView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var isAddGroupShowing: Bool = false
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension AllGroupView {
    
    private var statBar: some View {
        HStack {
            Text("Sheds:")
            Text("\(viewModel.sheds.count)")
            Spacer()
        }
        .font(.caption)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
    
    private var groupList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.sheds) { shed in
                    ShedRowView(shed: shed)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
            }
            .padding(.bottom, 75)
        }
    }
    
    private var addGroupOverLay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isAddGroupShowing.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("Group")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
}
