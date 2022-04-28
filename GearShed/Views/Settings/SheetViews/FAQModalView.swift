//
//  FAQModalView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-07.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct FAQModalView: View {
    @ObservedObject private var direct = Swipe.Direction.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Why the subscription?")
        }
        .padding()
    }
}

struct Swipe: ViewModifier {
    
    enum Direct {
        case swipeLeft
        case swipeRight
        case swipeUp
        case swipeDown
    }

    class Direction:ObservableObject {
        @Published var multi:[Direct] = []
        @Published var single:String!
        static var shared = Direction()
    }
  
    @GestureState private var dragDirection:[Direct] = []
    @State private var lastDragPosition: DragGesture.Value?
    @ObservedObject private var direct = Direction.shared
  
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture()
            .onChanged({ ( value ) in
                lastDragPosition = value
            })
            .updating($dragDirection, body: { (value, state, transaction) in
                if lastDragPosition != nil {
                    if (lastDragPosition?.location.x)! > value.location.x {
                        state += [.swipeLeft]
                    }
                    if (lastDragPosition?.location.x)! < value.location.x {
                      state += [.swipeRight]
                    }
                    if (lastDragPosition?.location.y)! < value.location.y {
                      state += [.swipeDown]
                    }
                    if (lastDragPosition?.location.y)! > value.location.y {
                      state += [.swipeUp]
                    }
                  }
                  direct.multi = state
                  print("\(direct.multi)")
                })
                .onEnded({ ( value ) in
                  let summary = direct.multi.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
                  let foo = summary.max { $0.value < $1.value }
                  direct.single = "\(foo!.key)!"
                  
                }))
    }
}
