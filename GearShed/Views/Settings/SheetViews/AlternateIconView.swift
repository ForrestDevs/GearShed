//
//  AlternateIconView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-04.
//

import SwiftUI

struct AlternateIconView: View {
    
   // @EnvironmentObject var iconSettings: IconNames
    
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

struct AlternateIconView_Previews: PreviewProvider {
    static var previews: some View {
        AlternateIconView()
    }
}


/*
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
     print ("\(value)")
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
 
 
 
 */
