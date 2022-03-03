//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var detailManager: DetailViewManager
    @State var isActive: Bool = true
    var body: some View {
        ZStack {
            AppTabBarView()
                .environmentObject(detailManager)
                .ignoresSafeArea(.all, edges: .bottom)
            DetailOverlay(type: detailManager.target, type2: detailManager.secondaryTarget, type3: detailManager.tertiaryTarget)
                .environmentObject(detailManager)
                .environmentObject(persistentStore)
            if self.isActive {
                LaunchAnimation()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeIn) {
                    self.isActive = false
                }
            }
        }
    }
}
