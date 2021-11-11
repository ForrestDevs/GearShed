//
//  Text+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-29.
//

import Foundation
import SwiftUI

extension Text {
    
    func formatEntryTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 15.5))
            .bold()
    }
    
    func formatBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatBlackTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    
    func formatBlackSmall() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatBlackSub() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 15))
    }
    
    func formatGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatGreen17Gradi() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatGreenTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    
    func formatGreenSmall() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatNoColorSmall() -> some View {
        self.font(.custom("HelveticaNeue", size: 18).bold())
    }
    
    func formatNoColorLarge() -> some View {
        self.font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    
}


extension TextField {
    
    func formatBlack() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatBlackTitle() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    
    func formatBlackSmall() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatBlackSub() -> some View {
        self.foregroundColor(Color.theme.accent)
            .font(.custom("HelveticaNeue", size: 12))
    }
    
    func formatGreen() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    func formatGreenTitle() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 22).bold())
    }
    
    func formatGreenSmall() -> some View {
        self.foregroundColor(Color.theme.green)
            .font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatNoColorSmall() -> some View {
        self.font(.custom("HelveticaNeue", size: 12).bold())
    }
    
    func formatNoColorLarge() -> some View {
        self.font(.custom("HelveticaNeue", size: 17).bold())
    }
    
    
}
