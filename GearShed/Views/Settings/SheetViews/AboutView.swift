//
//  AboutView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Image("mountainPic")
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .center)
                .padding(.bottom)
            
            Text("An App Built For The Adventurous")
                .formatGreenTitle()
            
            Text("""
                 As a father-son combo with too much gear to manage, we were in search of an app that could help us organize our uncontrollable amount of gear. Unfortunatly we couldn't find one that met our expectations, so we decieded to build one.
                 
                 Me, the son, being a computer science student and tech wizard, set out to learn the SwiftUI programming language to bring our idea to life.
                 
                 What began as an application to help solve our own needs, we quickly realized others might be in search of this same app as us.
                 
                 So we present Gear Shed, an app built by boots on the ground men for the people who have too much gear to keep track of.
                 """)
            .formatBlackSmall()
            .padding()
            
            HStack {
                Link(destination: URL(string: "https://www.gearshed.app")!) {
                    Text("Website")
                        .formatGreen()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.theme.green)
                            .opacity(0.3)
                    )
                }
                Link(destination: URL(string: "https://www.instagram.com/gearshedapp/")!) {
                    Text("Instagram")
                        .formatGreen()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.theme.green)
                            .opacity(0.3)
                    )
                }
                Link(destination: URL(string: "https://www.youtube.com/channel/UCGLuWaac-hzz0FYRXMOHqAg")!) {
                    Text("Youtube")
                        .formatGreen()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.theme.green)
                            .opacity(0.3)
                    )
                }
            }
        }
        .padding()
    }
}
