//
//  AlternateIconView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-04.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct AlternateIconView: View {
    @EnvironmentObject var persistentStore: PersistentStore
    @AppStorage("selectedIcon", store: .standard) var selectedIcon: String = "AppIcon"
    @State private var showUpgradeSheet: Bool = false
    private let radius: CGFloat = 14
    
    var body: some View {
        List {
            Button {
                if persistentStore.fullVersionUnlocked {
                    guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                    selectedIcon = "AppIcon"
                    UIApplication.shared.setAlternateIconName(nil) { error in
                        if let error = error { print(error.localizedDescription) }
                        else { print("Success!") }
                    }
                } else {
                    self.showUpgradeSheet.toggle()
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
                if persistentStore.fullVersionUnlocked {
                    guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                    selectedIcon = "DarkIcon"
                    UIApplication.shared.setAlternateIconName("DarkIcon") { error in
                        if let error = error { print(error.localizedDescription) }
                        else { print("Success!") }
                    }
                } else {
                    self.showUpgradeSheet.toggle()
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
                if persistentStore.fullVersionUnlocked {
                    guard UIApplication.shared.supportsAlternateIcons else { return print("Does Not Allow Icon Change") }
                    selectedIcon = "BlueIcon"
                    UIApplication.shared.setAlternateIconName("BlueIcon") { error in
                        if let error = error { print(error.localizedDescription) }
                        else { print("Success!") }
                    }
                } else {
                    self.showUpgradeSheet.toggle()
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
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Change App Icon", displayMode: .inline)
        .sheet(isPresented: $showUpgradeSheet) {
            UnlockView()
        }
        
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
