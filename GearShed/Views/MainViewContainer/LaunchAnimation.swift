//
//  LaunchAnimation.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-01-28.
//

import SwiftUI

struct ShedRoof: Shape {
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
    
    @State private var appear: Bool = false
    @State private var moveIt: Bool = false
    @State private var fadeAll: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                GeometryReader { geo in
                    let centerX = geo.frame(in: .local).midX
                    let centerY = geo.frame(in: .local).midY
                    ShedRoof()
                        .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
                        .frame(width: 220, height: 40)
                        .opacity(appear ? 1 : 0)
                        .position(x: centerX, y: centerY - 80)
                        .offset(y: moveIt ? -410 : 0)
                    HStack {
                        VStack (alignment: .center, spacing: -7) {
                            Text("GE ")
                                .font(.custom("HelveticaNeue", size: 65).bold().italic())
                            Text("SH ")
                                .font(.custom("HelveticaNeue", size: 65).bold().italic())
                        }
                        .position(x: centerX - 37, y: centerY + 35)
                        .offset(x: moveIt ? -210 : 0)
                        
                        VStack (alignment: .center, spacing: -7)  {
                            HStack (spacing: 0) {
                                Text("i")
                                    .opacity(0.0)
                                Text(" AR")
                                    .font(.custom("HelveticaNeue", size: 65).bold().italic())
                            }
                            Text(" ED")
                                .font(.custom("HelveticaNeue", size: 65).bold().italic())
                        }
                        .position(x: centerX - 164, y: centerY + 35)
                        .offset(x: moveIt ? 210 : 0)
                    }
                    .opacity(appear ? 1 : 0)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 1)) {
                        self.appear = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut(duration: 1)) {
                            self.appear = false
                            self.moveIt = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                self.fadeAll = true
                            }
                        }
                        
                    }
                    
                }
            }
        }
        .opacity(fadeAll ? 0 : 1)
        
    }
}

struct LaunchAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAnimation()
            .preferredColorScheme(.light)
    }
}


/*
 
 struct Example7: View {
     @State private var moveIt = false

     var body: some View {
         let animation = Animation.easeInOut(duration: 1.0)

         return VStack {
             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                 .animation(animation)

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .orange)
                 .animation(animation.delay(0.1))

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .yellow)
             .animation(animation.delay(0.2))

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .green)
                 .animation(animation.delay(0.3))

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .blue)
                 .animation(animation.delay(0.4))

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .purple)
             .animation(animation.delay(0.5))

             LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .pink)
             .animation(animation.delay(0.6))

             Button(action: { self.moveIt.toggle() }) { Text("Animate") }.padding(.top, 50)
         }
         .onTapGesture { self.moveIt.toggle() }
         .navigationBarTitle("Example 7")

     }
 }

 struct LabelView: View {
     let text: String
     var offset: CGFloat
     var pct: CGFloat
     let backgroundColor: Color

     var body: some View {

         Text("The SwiftUI Lab")
             .font(.headline)
             .padding(5)
             .background(RoundedRectangle(cornerRadius: 5).foregroundColor(backgroundColor))
             .foregroundColor(Color.black)
             .modifier(SkewedOffset(offset: offset, pct: pct, goingRight: offset > 0))

     }
 }
 
 
 VStack (alignment: .center, spacing: 15) {
     VStack {
         HStack {
             Button {
                 withAnimation(.spring()) {
                     //self.firstLaunch = true
                     intialRoofPosition = UIScreen.main.bounds.midY //+ 50
                 }
             } label: {
                 Text("Start")
             }
             Button {
                 withAnimation() {
                     self.firstLaunch = false
                 }
             } label: {
                 Text("End")
             }
         }
         Spacer()
     }
     
     ShedRoof()
         .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
         .frame(width: 220, height: 40)
         //.offset(intialRoofPosition)
         .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true).speed(4))
     
     
     if self.firstLaunch == true {
         ShedRoof()
             .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
             .frame(width: 220, height: 40)
             .offset(y: intialRoofPosition)
             //.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
             //.transition(.offset(x: , y: ))
             //.transition(AnyTransition.move(edge: .top))
     }
     
     if self.firstLaunch == true {
         VStack (alignment: .center, spacing: 0) {
             HStack {
                 VStack {
                     
                 }
                 VStack {
                     
                 }
             }
             Text("GEAR")
                 .font(.custom("HelveticaNeue", size: 65).bold().italic())
                 
                 //.transition(.offset(x: minX - 10))
             Text("SHED")
                 .font(.custom("HelveticaNeue", size: 65).bold().italic())
                 //.transition(.slide)

                 //.transition(.offset(x: maxX + 10))
         }
         .transition(.slide)
         
     }
     
     
 }
 .animation(.spring())
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
 
 
 VStack {
         GeometryReader { geo in
             let centerX = geo.frame(in: .local).midX
             let centerY = geo.frame(in: .local).midY
             
             
             
             ShedRoof()
                 .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
                 .frame(width: 220, height: 40)
                 .position(x: centerX, y: centerY - 80)
             
             Text("GEAR")
                 .font(.custom("HelveticaNeue", size: 65).bold().italic())
                 .position(x: centerX, y: centerY)
             
             Text("SHED")
                 .font(.custom("HelveticaNeue", size: 65).bold().italic())
                 .position(x: centerX, y: centerY + 70)
             
             HStack {
                 Text("GE ")
                     .font(.custom("HelveticaNeue", size: 65).bold().italic())
                     .position(x: centerX - 37, y: centerY)
                 Text(" AR")
                     .font(.custom("HelveticaNeue", size: 65).bold().italic())
                     .position(x: centerX - 162, y: centerY)
             }
             HStack {
                 Text("SH ")
                     .font(.custom("HelveticaNeue", size: 65).bold().italic())
                     .position(x: centerX - 37, y: centerY + 70)
                 Text(" ED")
                     .font(.custom("HelveticaNeue", size: 65).bold().italic())
                     .position(x: centerX - 163, y: centerY + 70)
             }
             
             
         }
         .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
 }
 .opacity(0.2)
 
 
 Rectangle()
     .frame(width: 2, height: 800, alignment: .center)
     .opacity(0.4)
 Rectangle()
     .frame(width: 500, height: 2, alignment: .center)
     .opacity(0.4)
 
 
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
 
 HStack {
     Button {
         withAnimation(.easeIn(duration: 1)) {
             self.appear = true
             //self.moveIt = true
             //self.offsetL = 0
             //self.offsetR = 0
         }
     } label: {
         Text("Start")
     }
     Button {
         withAnimation(.easeOut(duration: 1)) {
             //self.dim = false
             self.moveIt = true
             //self.offsetL = 120
             //self.offsetR = 120
         }
     } label: {
         Text("End")
     }
     
     Button {
         withAnimation(.easeOut(duration: 1)) {
             self.appear = false
             self.moveIt = false
             //self.offsetL = 120
             //self.offsetR = 120
         }
     } label: {
         Text("Reset")
     }
 }
 .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
 
 
 //let minX = UIScreen.main.bounds.minX
 //let maxX = UIScreen.main.bounds.maxX
 //Intial Roof Position
 //@State var intialRoofPosition: CGPoint = (x:UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY)
 //@State private var firstLaunch: Bool = false
 //@State private var half: Bool = false
 @State var offsetL: CGFloat = 0
 @State var offsetR: CGFloat = 0
 //@State var pct: CGFloat = 0
 
 struct SkewedOffset: GeometryEffect {
     var offset: CGFloat
     var pct: CGFloat
     let goingRight: Bool

     init(offset: CGFloat, pct: CGFloat, goingRight: Bool) {
         self.offset = offset
         self.pct = pct
         self.goingRight = goingRight
     }

     var animatableData: AnimatablePair<CGFloat, CGFloat> {
         get { return AnimatablePair<CGFloat, CGFloat>(offset, pct) }
         set {
             offset = newValue.first
             pct = newValue.second
         }
     }

     func effectValue(size: CGSize) -> ProjectionTransform {
         var skew: CGFloat

         if pct < 0.2 {
             skew = (pct * 5) * 0.5 * (goingRight ? -1 : 1)
         } else if pct > 0.8 {
             skew = ((1 - pct) * 5) * 0.5 * (goingRight ? -1 : 1)
         } else {
             skew = 0.5 * (goingRight ? -1 : 1)
         }

         return ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: offset, ty: 0))
     }
 }
 
 ZStack {
     Text("Hello")
     if appear {
         Color.blue
             .transition(.opacity)
     }
     
 }
 .onAppear {
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         withAnimation(.easeIn(duration: 1)) {
             self.appear = true
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             withAnimation(.easeOut(duration: 1)) {
                 self.appear = false
                 self.moveIt = true
             }
         }
     }
 }
 
 
 */
