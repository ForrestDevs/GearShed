//
//  CustomAlert.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-26.
//

import Foundation
import SwiftUI

struct AZAlert: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            TextField("New List Name", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }
                
                Spacer()
                
                Button("Done") {
                    self.isShown = false
                    self.onDone(self.text)
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.2)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)

    }
}
