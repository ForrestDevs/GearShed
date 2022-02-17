//
//  AlternateIconView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-04.
//

import SwiftUI

struct AlternateIconView: View {
    
    @EnvironmentObject var iconSettings: IconNames
    
    var body: some View {
        List {
            ForEach(0 ..< iconSettings.iconNames.count) { i in
                
                Button {
                    iconSettings.currentIndex = i
                } label: {
                    HStack(spacing:20) {
                        Image(uiImage: UIImage(named: self.iconSettings.iconNames[i] ?? "AppIcon") ?? UIImage())
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(self.iconSettings.iconNames[i] ?? "Default")
                        if iconSettings.currentIndex == i {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
            }
            .onReceive([self.iconSettings.currentIndex].publisher.first()) { value in
                let i = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                if value != i {
                    UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value], completionHandler: { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Success!")
                            }
                        }
                    )
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Change App Icon", displayMode: .inline)
    }
}

struct AlternateIconView_Previews: PreviewProvider {
    static var previews: some View {
        AlternateIconView()
    }
}
