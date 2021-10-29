//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let bottomEdge = proxy.safeAreaInsets.bottom
            
            AppTabBarView(bottomEdge: (bottomEdge == 0 ? 15 : bottomEdge))
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

