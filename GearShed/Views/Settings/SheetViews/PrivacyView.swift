//
//  PrivacyView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-07.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image(systemName: "lock.icloud")
                    .resizable()
                    .frame(width: 140, height: 100)
                    .foregroundColor(Color.theme.green)
                
                VStack (spacing: 5){
                    Text("Your data is Your data")
                        .formatBlackTitle()
                    
                    Text("Privacy is a priority for Gear Shed")
                        .formatBlack()
                }
                
                
                VStack (alignment: .leading, spacing: 5) {
                    Text("Gear Shed App stores all data on your device, and backups in your private iCloud.")
                    
                    
                    Text("Gear Shed does not collect any personal information without your consent")
                    
                    Text("Gear Shed does not share your information with any third party entities.")
                    
                    Text("If you [Erase All Content and Settings] in the settings tab, all App Data is deleted from your device. Please be careful with this operation, as without a backup, there is no way to recover your data once it is deleted.")
                    
                    Text("If you remove or uninstall this app from your phone all data will be deleted as well.")
                    
                    Text("Use Gear Shed at your own risk. We are not liable for any finacial decisions you make based on the app. We are also not responsible for your data and do not provide warrenties.")
                }
                
                HStack {
                    Image(systemName: "person.icloud")
                    
                    VStack {
                        Text("Private iCloud")
                        Text("""
                            All of the data entered into this app is stored in YOUR private iCloud with Apple's privacy standards. As the developer, I do not have access to any information stored in this app.
                            """)
                    }
                }
                
                HStack {
                    Image(systemName: "eyes.inverse")
                    
                    VStack {
                        Text("No Analytics")
                        Text("""
                             I do not use any analytics software to track how you are using Gear Shed.
                             """)
                    }
                }
                // Button to website PP and TOS
                /*HStack {
                    
                    Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/privacy.html")!) {
                        HStack {
                            Image(systemName: "lock.icloud.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                            Text("Privacy Policy")
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                        )
                    }
                    Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/terms.html")!) {
                        HStack {
                            Image(systemName: "doc.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                            Text("Terms of Service")
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                        )
                    }
                }*/
            }
            .padding()
            .padding(.bottom, 60)
        }
    }
}
