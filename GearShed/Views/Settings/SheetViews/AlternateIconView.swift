//
//  AlternateIconView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-04.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AlternateIconView: View {
    
    
    private let radius: CGFloat = 14
    
    @AppStorage("selectedIcon", store: .standard) var selectedIcon: String = "AppIcon"
    
    var body: some View {
        List {
            Button {
                guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                selectedIcon = "AppIcon"
                UIApplication.shared.setAlternateIconName(nil) { error in
                    if let error = error { print(error.localizedDescription) }
                    else { print("Success!") }
                }
            } label: {
                HStack {
                    Image(uiImage: getAppIcon())
                        .cornerRadius(radius)
                    Text("Original")
                    if selectedIcon == "AppIcon" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Button {
                guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                selectedIcon = "DarkIcon"
                UIApplication.shared.setAlternateIconName("DarkIcon") { error in
                    if let error = error { print(error.localizedDescription) }
                    else { print("Success!") }
                }
            } label: {
                HStack {
                    Image(uiImage: getAltAppIcon(iconName: "DarkIcon"))
                        .cornerRadius(radius)
                    Text("Dark")
                    if selectedIcon == "DarkIcon" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Button {
                guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                selectedIcon = "BlueIcon"
                UIApplication.shared.setAlternateIconName("BlueIcon") { error in
                    if let error = error { print(error.localizedDescription) }
                    else { print("Success!") }
                }
            } label: {
                HStack {
                    Image(uiImage: getAltAppIcon(iconName: "BlueIcon"))
                        .cornerRadius(radius)
                    Text("Blue")
                    if selectedIcon == "BlueIcon" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Button {
                guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                selectedIcon = "RGBIcon"
                UIApplication.shared.setAlternateIconName("RGBIcon") { error in
                    if let error = error { print(error.localizedDescription) }
                    else { print("Success!") }
                }
            } label: {
                HStack {
                    Image(uiImage: getAltAppIcon(iconName: "RGBIcon"))
                        .cornerRadius(radius)
                    Text("RGB")
                    if selectedIcon == "RGBIcon" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            
//            Button {
//                UIApplication.shared.setAlternateIconName(nil)
//            } label: {
//                HStack {
//                    Image("AppIcon")
//                        .cornerRadius(20)
//                    Text("Light")
//                }
//                
//            }
//            
//            Button {
//                UIApplication.shared.setAlternateIconName("RGBIcon")
//            } label: {
//                HStack {
//                    Image("RGBIcon")
//                        .cornerRadius(20)
//                    Text("RGB")
//                }
//            }
//
//            
//            Button {
//                UIApplication.shared.setAlternateIconName("DarkIcon") { error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("Success!")
//                    }
//                }
//            } label: {
//                HStack {
//                    Image("DarkIcon")
//                        .cornerRadius(20)
//                    Text("Dark")
//                }
//            }
//            
//            Button {
//                UIApplication.shared.setAlternateIconName("BlueIcon") { error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("Success!")
//                    }
//                }
//            } label: {
//                HStack {
//                    Image("BlueIcon")
//                        .cornerRadius(20)
//                    Text("Blue")
//                }
//            }
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Change App Icon", displayMode: .inline)
    }
    
    func getAppIcon() -> UIImage {
        var appIcon: UIImage! {
            guard let iconDir = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
                  let primaryIconDir = iconDir["CFBundlePrimaryIcon"] as? [String:Any],
                  let iconFiles = primaryIconDir["CFBundleIconFiles"] as? [String],
                  let lastIcon = iconFiles.last else { return nil }
            
            return UIImage(named: lastIcon)
        }
        return appIcon
    }
    
    func getAltAppIcon(iconName: String) -> UIImage {
        var appIcon: UIImage! {
            guard let iconDir = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
                  let altIconDir = iconDir["CFBundleAlternateIcons"] as? [String:Any],
                  let iconName = altIconDir["\(iconName)"] as? [String:Any],
                  let iconFiles = iconName["CFBundleIconFiles"] as? [String],
                  let lastIcon = iconFiles.last else { return nil }
            
            return UIImage(named: lastIcon)
        }
        return appIcon
    }
}
