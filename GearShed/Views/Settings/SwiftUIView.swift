//
//  SwiftUIView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//

import SwiftUI

struct SwiftUIView: View {
    @State var text: String = ""
    @State private var tapped: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("PDF Username:")
                        TextField("username", text: $text)
                    }
                    HStack {
                        Text("Weight Unit:")
                        Button {
                            self.tapped.toggle()
                        } label: {
                            HStack {
                                Text("g")
                                    .foregroundColor(tapped ? .black : .blue)
                                    .padding(.leading, 10)
                                Image(systemName: "checkmark")
                                    .foregroundColor(tapped ? .black : .blue)
                                    .opacity(tapped ? 0 : 1)
                                    .padding(.trailing, 5)
                                
                                Text("lbs + oz")
                                    .foregroundColor(tapped ? .blue : .black)
                                Image(systemName: "checkmark")
                                    .foregroundColor(tapped ? .blue : .black)
                                    .opacity(tapped ? 1 : 0)
                            }
                        }
                    }
                    Button {} label: {
                        HStack {
                            Text("Color Scheme")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Button {} label: {
                        HStack {
                            Text("Alternate App Icon")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Button {} label: {
                        HStack {
                            Text("Change Status Icon")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                } header: {
                    Text("Preferences")
                }
                
                Section {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.doc.fill")
                            Text("Create Offline Backup")
                        }
                        
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.doc.fill")
                            Text("Load From Backup")
                        }
                        
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Erase All Content and Settings")
                        }
                        .foregroundColor(.red)
                    }
                } header: {
                    Text("Database Management")
                }
                
                Section {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("Restore Purchases")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "lock.open")
                            Text("Unlock Pro")
                        }
                        
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("Tip The Developer")
                        }
                        
                    }
                    
                } header: {
                    Text("In App purchases")
                }
                
                Section {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "hand.wave")
                            Text("About")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "message")
                            Text("Feedback")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "lock.icloud")
                            Text("Privacy Policy & Terms of Service")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                } header: {
                    Text("More Information")
                } footer: {
                    Text("Version: 0.10, Build: 15")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                viewTitle
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Settings")
                .formatGreen()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .preferredColorScheme(.light)
    }
}
