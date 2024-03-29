//
//  Transition+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-23.
//  Copyright © 2022 All rights reserved.
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

extension AnyTransition {
    static var fly: AnyTransition { get {
        AnyTransition.modifier(active: FlyTransition(pct: 0), identity: FlyTransition(pct: 1))
        }
    }
}

struct FlyTransition: GeometryEffect {
    var pct: Double
    
    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {

        let rotationPercent = pct
        let a = CGFloat(Angle(degrees: 90 * (1-rotationPercent)).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(pct * 2), y: CGFloat(pct * 2)))
        
        if pct <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}



