//
//  ConfirmEraseView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-08.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ConfirmEraseView: View {
    
    var completion: (() -> Void)
    @StateObject var persistentStore: PersistentStore
    @StateObject var detailManager: DetailViewManager
    @State private var eraseText: String = ""
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .opacity(0.2)
                .onTapGesture {
                    withAnimation {
                        detailManager.target = .noView
                    }
                }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width / 1.2, height: height / 3)
                    .foregroundColor(Color.theme.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .frame(width: width / 1.2, height: height / 3)
                            .foregroundColor(Color.theme.green)
                    )
                
                VStack(alignment: .center, spacing: 10) {
                    Text("WARNING")
                        .foregroundColor(.red)
                        .bold()
                    Text("""
                        This will completly delete all data in your Gear Shed app, as well as iCloud synced data.\n
                        If you wish to proceed please type \"Erase\" to confirm.
                        """)
                    .formatBlackSmall()
                    
                    TextField("Type 'Erase'", text: $eraseText)
                        .padding(7)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.theme.boarderGrey, lineWidth: 1)
                        )
                    
                    HStack {
                        Button {
                            guard eraseText == "Erase" else { return }
                            persistentStore.deleteAllEntities()
                            withAnimation {
                                detailManager.target = .noView
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                completion()
                            }
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.red)
                                    .opacity(0.8)
                                    .frame(width: width / 3, height: height / 15)
                                Text("Delete all data")
                                    .brightness(5)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Button {
                            withAnimation {
                                detailManager.target = .noView
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.theme.green)
                                    .opacity(0.8)
                                    .frame(width: width / 3, height: height / 15)
                                Text("Cancel")
                                    .brightness(5)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: width / 1.2, height: height / 3)
                
            }
        }
    }
}
