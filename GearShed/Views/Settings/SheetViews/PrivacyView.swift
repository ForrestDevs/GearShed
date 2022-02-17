//
//  PrivacyView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-07.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        VStack {
            Image(systemName: "lock.icloud")
            Text("Your data is your data")
            Text("Privacy is a priority for Gear Shed")
            
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
            
            HStack {
                
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
            }
        }
        
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
