//
//  AboutView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("mountainPic")
                    .resizable()
                    .clipShape(Circle())
                    //.frame(maxWidth: .infinity)
                    .frame(width: 200, height: 200, alignment: .center)
                Text("An App Built For The Adventurous")
                Text("By The Adventurous")
                
                Text("""
                     As a father-son combo with too much gear to manage, we were in search of an app that could help us organize our uncontrollable amount of gear. Unfortunatly we couldn't find one that met our expectations, so we decieded to build one.
                     
                     Me, the son, being a computer science student and tech wizard, set out to learn the SwiftUI programming language to bring our idea to life.
                     
                     What began as an application to help solve our own needs, we quickly realized others might be in search of this same app as us.
                     
                     So we present Gear Shed, an app built by boots on the ground men for the people who have too much gear to keep track of.
                     """)
                    .padding()
                VStack {
                    Link(destination: URL(string: "https://www.gearshed.app")!) {
                        HStack {
                            Image("gstransparent")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                            Text("Website")
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                        )
                    }
                    
                    Link(destination: URL(string: "https://www.instagram.com/gearshedapp/")!) {
                        HStack {
                            Image("IGLogo")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text("Instagram")
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                        )
                    }
                    
                    Link(destination: URL(string: "https://www.youtube.com/channel/UCGLuWaac-hzz0FYRXMOHqAg")!) {
                        HStack {
                            Image("youtubeLogo")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .scaledToFit()
                                //.frame(width: 60, height: 40)
                                
                            Text("Youtube")
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                        )
                    }
                }
                
            }
        }
      
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
