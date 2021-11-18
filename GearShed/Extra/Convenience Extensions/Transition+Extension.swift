//
//  Transition+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-23.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension AnyTransition {
    
    static func consecuativeMove(type: String) -> AnyTransition {
        var offset: CGFloat = 0
        
        if type == "item" {
            offset = 430
        } else if type == "shed" {
            offset = 370
        } else if type == "brand" {
            offset = 310
        } else if type == "wish" {
            offset = 250
        }
        
        //let insertion = AnyTransition.move(edge: .bottom)
        let insertion = AnyTransition.offset(y: offset)
            .combined(with: .move(edge: .bottom))
        
            
        let removal = AnyTransition.move(edge: .bottom)
            //.combined(with: .offset(y: offset))

            
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    
    static var moveAndScale: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .scale)
            
        let removal = AnyTransition.move(edge: .bottom)
            .combined(with: .scale)

            
        return .asymmetric(insertion: insertion, removal: removal)
        
    }
    
}


