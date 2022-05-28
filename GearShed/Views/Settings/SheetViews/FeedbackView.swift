//
//  FeedbackView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-07.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    @State private var mailData = ComposeMailData(
        subject: "Gear Shed Feedback",
        recipients: ["info@gearshed.com"],
        message: ""
    )
    @State private var showMailView = false
    var body: some View {
        VStack (spacing: 25) {
            Image(systemName: "message")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.theme.green)
            Text("How can Gear Shed be better?")
                .formatBlackTitle()
            Text("""
            As an independent developer, I strive to make the best tool possible.
            
            I built version 1.0 to meet my father's own specfic needs as an adventurous gear head, however I will continue to add features and functionality based on user feeback.
            
            I'd love your help! If you would like to provide feedback to improve Gear Shed, please reach out. I'm happy to communicate via email or social media DM's.
            
            Many Thanks!
            """)
            .formatBlackSmall()
            .padding()
            
            HStack (spacing: 10) {
                Button {
                    showMailView.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 110, height: 55)
                            .foregroundColor(Color.theme.green)
                            .opacity(0.5)
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Email")
                        }
                    }
                }
                .disabled(!MailView.canSendMail)
                .sheet(isPresented: $showMailView) {
                    MailView(data: $mailData) { result in
                        print(result)
                    }
                }
                Link(destination: URL(string: "https://twitter.com/gearshedapp")!) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 110, height: 55)
                            .foregroundColor(Color.theme.green)
                            .opacity(0.5)
                        HStack {
                            Image("twitterLogo")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Twitter")
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .padding(.top, 10)
    }
}
