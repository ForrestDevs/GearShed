//
//  ContentView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var detailManager: DetailViewManager
    
    init() {
        let detailManager = DetailViewManager()
        _detailManager = StateObject(wrappedValue: detailManager)
    }
    
    var body: some View {
        AppTabBarView()
            .environmentObject(detailManager)
            .ignoresSafeArea(.all, edges: .bottom)
            //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(detailManager.showGearlistDetail ? detailManager.content.animation(.default, value: detailManager.showGearlistDetail) : nil)
    }
}


struct tger: View {
    @State var isShowSheet: Bool = false
    
    var body: some View {
        VStack{
            Button("Show Sheet") {
                withAnimation {
                    isShowSheet.toggle()
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .overlay(isShowSheet ? FullScreen(isShowSheet: $isShowSheet.animation()) : nil)
    }
}

struct FullScreen: View {
    
    @Binding var isShowSheet: Bool

    
    var body: some View {
        Color.blue
            .transition(.move(edge: .leading))
            .onTapGesture {
                isShowSheet = false
            }
            .edgesIgnoringSafeArea(.all)
    }
}

class DetailViewManager: ObservableObject {
    
    @Published var showGearlistDetail: Bool = false
    
    @Published var content: AnyView = AnyView(EmptyView())
    
    init() {
        
    }
}





