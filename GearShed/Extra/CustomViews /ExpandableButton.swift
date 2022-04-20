//
//  ExpandableButton.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-15.
//
import SwiftUI

struct ExpandableButton: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var vm: ShedItemsViewModel
    @EnvironmentObject private var gsData: GearShedData
    @State private var showMenuItem1 = false
    @State private var showMenuItem2 = false
    @State private var showMenuItem3 = false
    @State private var isExpanded = false
    @State private var isClose = false
    
    enum ButtonType {
        case item, shed, brand
    }

    var type: ButtonType
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack (alignment: .center, spacing: 2) {
                    
                    VStack (alignment: .center, spacing: 1) {
                        
                        if showMenuItem1 {
                            menuButton(type: .item, buttonText: "Gear")
                        }
                        if showMenuItem2 {
                            menuButton(type: .shed, buttonText: "Shelf")
                        }
                        
                        /*if type == .shed {
                            if showMenuItem1 {
                                menuButton(type: .item, buttonText: "Gear")
                            }
                            if showMenuItem2 {
                                menuButton(type: .shed, buttonText: "Shed")
                            }
                        }
                        if type == .brand {
                            if showMenuItem1 {
                                menuButton(type: .item, buttonText: "Gear")
                            }
                            if showMenuItem3 {
                                menuButton(type: .brand, buttonText: "Brand")
                            }
                        }*/
                    }
                    
                    // "+" button to show menu
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
                .padding(.bottom, 50)
            }
        }
        
    }
    
    func showMenu() {
        
        if isClose {
            withAnimation {
                showMenuItem2 = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                withAnimation {
                    showMenuItem1 = false
                }
            })
        } else {
            withAnimation {
                showMenuItem1 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                withAnimation {
                    showMenuItem2 = true
                }
            })
        }
        
        /*if type == .shed {
            if isClose {
                withAnimation {
                    showMenuItem2 = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                    withAnimation {
                        showMenuItem1 = false
                    }
                })
            } else {
                withAnimation {
                    showMenuItem1 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                    withAnimation {
                        showMenuItem2 = true
                    }
                })
            }
        }*/
        /*if type == .brand {
            if isClose {
                withAnimation {
                    showMenuItem3 = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                    withAnimation {
                        showMenuItem1 = false
                    }
                })
            } else {
                withAnimation {
                    showMenuItem1 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
                    withAnimation {
                        showMenuItem3 = true
                    }
                })
            }
        }*/
        
        isClose.toggle()
        isExpanded.toggle()
    }
    
    func menuButton(type: ButtonType, buttonText: String) -> some View {
        Button {
            switch type {
            case .item:
                if gsData.verifyUnlimitedGear() {
                    detailManager.target = .noView
                    withAnimation {
                        detailManager.target = .showAddItem
                    }
                    showMenu()
                } else {
                    vm.showingUnlockView.toggle()
                }
            case .shed:
                detailManager.tertiaryTarget = .noView
                withAnimation {
                    detailManager.tertiaryTarget = .showAddShed
                }
                showMenu()
            case .brand:
                detailManager.tertiaryTarget = .noView
                withAnimation {
                    detailManager.tertiaryTarget = .showAddBrand
                }
                showMenu()
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

