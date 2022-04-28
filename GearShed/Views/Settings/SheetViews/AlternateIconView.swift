//
//  AlternateIconView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-04.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AlternateIconView: View {
    var body: some View {
        List {
            Button {
                UIApplication.shared.setAlternateIconName(nil)
            } label: {
                HStack {
                    Image("AppIcon")
                        .cornerRadius(20)
                    Text("Light")
                }
                
            }
            
            Button {
                UIApplication.shared.setAlternateIconName("RGBIcon")
            } label: {
                HStack {
                    Image("RGBIcon")
                        .cornerRadius(20)
                    Text("RGB")
                }
            }

            
            Button {
                UIApplication.shared.setAlternateIconName("DarkIcon") { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Success!")
                    }
                }
            } label: {
                HStack {
                    Image("DarkIcon")
                        .cornerRadius(20)
                    Text("Dark")
                }
            }
            
            Button {
                UIApplication.shared.setAlternateIconName("BlueIcon") { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Success!")
                    }
                }
            } label: {
                HStack {
                    Image("BlueIcon")
                        .cornerRadius(20)
                    Text("Blue")
                }
            }
            
                    }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Change App Icon", displayMode: .inline)
    }
}
