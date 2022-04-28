//
//  ColorSchemeView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-07.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ColorSchemeView: View {
    var body: some View {
        List {
            Button {
                Prefs.shared.isSystemMode = true
            } label: {
                HStack {
                    Text("System")
                    Spacer()
                    if Prefs.shared.isSystemMode == true {
                        Image(systemName: "checkmark")
                    }
                }
            }
            Button {
                Prefs.shared.isSystemMode = false
                Prefs.shared.isDarkMode = false
            } label: {
                HStack {
                    Text("Light")
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(Prefs.shared.isSystemMode == false && Prefs.shared.isDarkMode == false ? 1 : 0)
                    
                }
            }
            Button {
                Prefs.shared.isDarkMode = true
                Prefs.shared.isSystemMode = false
            } label: {
                HStack {
                    Text("Dark")
                    Spacer()
                    if Prefs.shared.isSystemMode == false && Prefs.shared.isDarkMode == true {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
