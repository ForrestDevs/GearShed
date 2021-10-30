//
//  AllShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllShedView: View {
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: GearShedData
    
    @State private var isAddShedShowing: Bool = false
    @State private var isAlertShowing: Bool = false
    @State private var newShedName: String = ""
    @State private var shed1: Shed? = nil
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                shedList
                addShedOverLay
                alertOverlay
            }
        }
        .fullScreenCover(isPresented: $isAddShedShowing) {
            NavigationView {
                AddShedView()
            }
        }
    }
    
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
    
    private var shedList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.sheds) { shed in
                    ShedRowView(shed: shed)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .contextMenu { shedRowContextMenu(editTrigger: {
                            shed1 = shed
                            isAlertShowing = true
                        }, deletionTrigger: {
                            Shed.delete(shed)
                        })}
                }
            }
            .padding(.bottom, 75)
        }
    }
    
    private var addShedOverLay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isAddShedShowing.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("Shed")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 75)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
    private var alertOverlay: some View {
        AZAlert(title: "Rename Shed", isShown: $isAlertShowing, text: $newShedName) { text in
            shed1?.updateName(shed: shed1!, name: text)
            newShedName = ""
        }
    }
}

