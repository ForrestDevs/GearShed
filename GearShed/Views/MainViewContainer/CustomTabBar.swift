//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Balaji on 13/08/21.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            topBorder
            HStack (spacing: 55) {
                homeButton
                gearShedButton
                gearListButton
            }
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.background)
    }
    
    private var topBorder: some View {
        Rectangle()
            .foregroundColor(Color.theme.green)
            .frame(maxWidth: .infinity)
            .frame(height: 1.5)
    }
    
    private var homeButton: some View {
        Button {
            withAnimation{currentTab = "Home"}
        } label: {
            VStack(alignment: .center) {
                Image(systemName: "house")
                Text("Home")
                    .formatNoColorSmall()
            }
            .foregroundColor(
                currentTab == "Home" ?
                    withAnimation(.easeInOut) {
                        Color.theme.green
                    } : withAnimation(.easeInOut) {
                        Color.theme.accent
                    }
            )
        }
    }
    
    private var gearShedButton: some View {
        Button {
            withAnimation{currentTab = "GearShed"}
        } label: {
            VStack (alignment: .center, spacing: 0) {
                Image(systemName: "magazine")
                
                Text("GearShed")
                    .formatNoColorSmall()
            }
            .foregroundColor(
                currentTab == "GearShed" ?
                    withAnimation(.easeInOut) {
                        Color.theme.green
                    } : withAnimation(.easeInOut) {
                        Color.theme.accent
                    }
            )
        }
    }

    private var gearListButton: some View {
        Button {
            withAnimation{currentTab = "Gearlist"}
        } label: {
            VStack (alignment: .center, spacing: 0) {
                Image(systemName: "list.bullet.rectangle")
                Text("GearList")
                    .formatNoColorSmall()
            }
            .foregroundColor(
                currentTab == "Gearlist" ?
                    withAnimation(.easeInOut) {
                        Color.theme.green
                    } : withAnimation(.easeInOut) {
                        Color.theme.accent
                    }
            )
        }
    }
}


