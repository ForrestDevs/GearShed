//
//  ExpandableButton.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//

import SwiftUI

struct ExpandableButton: View {
    
    @State private var showMenuItem1 = false
    @State private var showMenuItem2 = false
    @State private var showMenuItem3 = false
    @State private var showMenuItem4 = false
    @State private var isExpanded = false
    @State private var isClose = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack (alignment: .center, spacing: 2) {
                    
                    VStack (alignment: .center, spacing: 1) {
                        if showMenuItem1 {
                            MenuButtons(type: .item, buttonText: "Item")
                        }
                        if showMenuItem2 {
                            MenuButtons(type: .shed, buttonText: "Shed")
                        }
                        if showMenuItem3 {
                            MenuButtons(type: .brand, buttonText: "Brand")
                        }
                    }
                    
                    
                    Button {
                        showMenu()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.theme.background)
                            .rotationEffect(.degrees(isExpanded ? 135: 0))
                            .animation(.easeInOut(duration: 0.35))
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
    
    func showMenu() {
        if isClose {
            withAnimation {
                showMenuItem3 = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                withAnimation {
                    showMenuItem2 = false
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                withAnimation {
                    showMenuItem1 = false
                }
            })
        } else {
            withAnimation {
                showMenuItem1 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                withAnimation {
                    showMenuItem2 = true
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                withAnimation {
                    showMenuItem3 = true
                }
            })
        }
        isClose.toggle()
        isExpanded.toggle()
    }
    
}

struct MenuButtons: View {
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    enum ButtonType: String {
        case item, shed, brand, wish
    }
    
    var type: ButtonType
    
    var buttonText: String
    
    var body: some View {
        Button {
            if type == .item {
                withAnimation {
                    detailManager.showAddItem = true
                }
            } else if type == .shed {
                withAnimation {
                    detailManager.showAddShed = true
                }
            } else if type == .brand {
                withAnimation {
                    detailManager.showAddBrand = true
                }
            }
        } label: {
            VStack {
                Text("Add")
                Text(buttonText)
            }
            .foregroundColor(Color.theme.background)
            .font(.system(size: 12, weight: .regular))
        }
        .frame(width: 55, height: 55)
        .background(Color.theme.accent)
        .cornerRadius(38.5)
        .padding(.bottom, 5)
        .padding(.trailing, 15)
        .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
        .transition(.move(edge: .bottom))
    }
}
