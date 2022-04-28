//
//  LaunchAnimation.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-01-28.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct LaunchAnimation: View {
    @State private var appear: Bool = false
    @State private var moveIt: Bool = false
    @State private var fadeAll: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(.all, edges: .bottom)
            VStack (spacing: -10) {
                Image("roofVector")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(appear ? 1 : 0)
                
                Text("GEAR")
                    .font(.custom("HelveticaNeue", size: 65).bold().italic())
                    .offset(x: moveIt ? 0 : -300)
                
                Text("SHED")
                    .font(.custom("HelveticaNeue", size: 65).bold().italic())
                    .offset(x: moveIt ? 0 : 330)
            }
            .frame(width: UIScreen.main.bounds.width / 1.7, height: UIScreen.main.bounds.height / 3.5, alignment: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 1.5)) {
                        self.appear = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.moveIt = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 1)) {
                                self.fadeAll = true
                            }
                        }
                    }
                }
            }
        }
        .opacity(fadeAll ? 0 : 1)
    }
}
