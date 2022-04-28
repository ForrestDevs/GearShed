//
//  CustomAlert.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-26.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

struct AZAlert: View {
    @Binding var isShown: Bool
    @Binding var text: String
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    var textFeildPH: String = ""
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    var body: some View {
        ZStack{
            Color.white
                .opacity(0.9)
                .ignoresSafeArea()
            
            Color.black
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack (spacing: 15){
                Text(title)
                    .font(.headline)
                TextField(textFeildPH, text: $text)
                HStack {
                    Spacer()
                    Button {
                        self.isShown = false
                        self.onCancel()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                    Button {
                        self.isShown = false
                        self.onDone(self.text)
                    } label : {
                        Text("Done")
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                }
            }
            .padding()
            .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.15)
            .background(
                Color.gray
            )
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            //.shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
        }
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
    }
}
