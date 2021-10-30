//
//  Text+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import Foundation
import SwiftUI

extension Text {
    
    func formatBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatBlackSmall() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatGreenSmall() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
}
