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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                VStack (alignment: .center, spacing: 10) {
                    Image(systemName: "lock.icloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.theme.green)
                    Text("Privacy is a priority for Gear Shed")
                        .formatBlackTitle()
                }
                VStack (alignment: .leading, spacing: 15) {
                    VStack (alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "person.icloud")
                                .foregroundColor(.theme.green)
                            Text("Private iCloud")
                                .formatGreenTitle()
                        }
                        Text("""
                            Gear Shed stores all data on your device and private iCloud with Apple's privacy standards.\n
                            As the developer, I do not have access to any information stored in this app.
                            """)
                        .formatBlackSmall()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "eyes")
                                .foregroundColor(.theme.green)
                            Text("No Analytics")
                                .formatGreenTitle()
                        }
                        Text("""
                            Gear Shed does not use any analytics software to track how you are using the app.\n
                            Gear Shed does not collect any personal information without your consent. Nor does it share your information with any third party entities.
                            """)
                            .formatBlackSmall()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.theme.green)
                            Text("Data Deletion")
                                .formatGreenTitle()
                        }
                        Text("""
                            If you [Erase All Content and Settings] in the settings tab, all app data is deleted from your device and private iCloud.\n
                            Please be careful with this operation, as without a backup, there is no way to recover your data once it is deleted.\n
                            If you remove or uninstall this app from your phone all data on your device will be deleted.
                            """)
                            .formatBlackSmall()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.theme.green)
                            Text("Disclaimer")
                                .formatGreenTitle()
                        }
                        Text("Use Gear Shed at your own risk. We are not liable for any finacial decisions you make based on the app. We are also not responsible for your data and do not provide warrenties.")
                            .formatBlackSmall()
                    }
                }
                HStack {
                    Spacer()
                    VStack (alignment: .leading, spacing: 10) {
                        Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/privacy.html")!) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 180, height: 55)
                                    .foregroundColor(Color.theme.green)
                                    .opacity(0.5)
                                HStack {
                                    Image(systemName: "lock.icloud.fill")
                                    Text("Privacy Policy")
                                }
                            }
                        }
                        Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/terms.html")!) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 180, height: 55)
                                    .foregroundColor(Color.theme.green)
                                    .opacity(0.5)
                                HStack {
                                    Image(systemName: "doc.fill")
                                    Text("Terms of Service")
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
            }
            .padding()
        }
    }
}
