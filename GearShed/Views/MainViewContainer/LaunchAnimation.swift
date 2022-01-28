//
//  LaunchAnimation.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-01-28.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}

struct Star: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    let corners: Int
    let smoothness: CGFloat
    
    func path1(in rect: CGRect) -> Path {
        
        let top = CGPoint(x: rect.width / 2, y: rect.maxY)
        let start = CGPoint(x: rect.width / 2, y: rect.maxY - rect.height / 4)
        
        var path = Path()
        
        path.move(to: top)
        path.addLine(to: start)
        
        return path
    }

    func path(in rect: CGRect) -> Path {
        // ensure we have at least two corners, otherwise send back an empty path
        guard corners >= 2 else { return Path() }

        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2

        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)

        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness

        // we're ready to start with our path now
        var path = Path()

        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))

        // track the lowest point we draw to, so we can center later
        var bottomEdge: CGFloat = 0

        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat

            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point

                // store this Y position
                bottom = innerY * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }

            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }

            // move on to the next corner
            currentAngle += angleAdjustment
        }

        // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2

        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}

struct ShedRoof : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY + 15))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY + 15))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY + 15))
        path.closeSubpath()
        return path
    }
}

struct LaunchAnimation: View {
    
    @State private var firstLaunch: Bool = false
    
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    
    var body: some View {
        VStack (alignment: .center, spacing: 15) {
            
            if self.firstLaunch == true {
                
                ShedRoof()
                    .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
                    .frame(width: 220, height: 40)
                    .transition(AnyTransition.move(edge: .top))
            }
            
            if self.firstLaunch == true {
                VStack (alignment: .center, spacing: 0) {
                    Text("GEAR")
                        .font(.custom("HelveticaNeue", size: 65).bold().italic())
                        .transition(.offset(x: minX - 10))
                    Text("SHED")
                        .font(.custom("HelveticaNeue", size: 65).bold().italic())
                        .transition(.offset(x: maxX + 10))
                }
                
            }
            
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    self.firstLaunch = true
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation (.easeOut) {
                    self.firstLaunch = false
                }
            }
        }
    }
}

struct LaunchAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAnimation()
    }
}
