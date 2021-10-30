//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Balaji on 13/08/21.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: String
    
    var bottomEdge: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            
            Button {
                withAnimation{currentTab = "Home"}
            } label: {
                Text("Home")
            }
            Button {
                withAnimation{currentTab = "GearShed"}
            } label: {
                Text("GearShed")
            }
            Button {
                withAnimation{currentTab = "Gearlist"}
            } label: {
                Text("Gearlist")
            }
        }
        .padding(.top,15)
        .padding(.bottom,bottomEdge)
        .padding(.horizontal, 10)
        .background(
            Color.theme.green
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


/// An environment singleton responsible for managing the Tab Bar
final class TabBarManager: ObservableObject {
    
    private(set) static var shared = TabBarManager()
    
    @Published var hideTab: Bool = false
    
}


/*struct TabButton: View {
    
    var image: String
    @Binding var currentTab: String
    
    // Based On Color SCheme changing Color...
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        Button {
            
            withAnimation{currentTab = image}
            
        } label: {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(currentTab == image ? Color("Pink") : Color.gray.opacity(0.7))
                .frame(maxWidth: .infinity)
        }

    }
}*/
