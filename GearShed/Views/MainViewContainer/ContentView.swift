//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var detailManager: DetailViewManager
    @State var isActive: Bool = true
    var body: some View {
        if isActive {
            LaunchAnimation()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeIn) {
                            self.isActive = false
                        }
                    }
                }
                .transition(.opacity.animation(.default))
        } else {
            ZStack {
                AppTabBarView()
                    .environmentObject(detailManager)
                DetailOverlay(type: detailManager.target, type2: detailManager.secondaryTarget, type3: detailManager.tertiaryTarget)
                    .environmentObject(detailManager)
                    .environmentObject(persistentStore)
            }
            .transition(.opacity.animation(.default))
        }
    }
}
