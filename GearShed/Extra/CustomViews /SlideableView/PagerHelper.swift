//
//  PagerHelper.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct PagerTabView<Content: View, Label: View>: View {
    var content: Content
    var label: Label
    var tint: Color
    @Binding var selection: Int
    init(tint: Color, selection: Binding<Int>, @ViewBuilder labels: @escaping ()->Label,@ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self.label = labels()
        self.tint = tint
        self._selection = selection
    }
    // Offset for Page Scroll...
    @State var offset: CGFloat = 0
    @State var maxTabs: CGFloat = 0
    @State var tabOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 3) {
            ZStack (alignment: .center) {
                // Indicator...
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.theme.green, lineWidth: 1)
                    .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 25)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .offset(x: tabOffset)
                HStack(spacing: 0) {
                    label
                }
                // For Tap to change tab...
                .overlay(
                    HStack(spacing: 0){
                            ForEach(0..<Int(maxTabs),id: \.self){ index in
                                Rectangle()
                                    .fill(Color.black.opacity(0.01))
                                    .onTapGesture {
                                        // Changing Offset...
                                        // Based on Index...
                                        let newOffset = CGFloat(index) * getScreenBounds().width
                                        self.offset = newOffset
                                        self.selection = index
                                        //print("\(selection)")
                                    }
                            }
                        }
                    )
                .foregroundColor(tint)
            }
            
            OffsetPageTabView(selection: $selection, offset: $offset) {
                HStack(spacing: 0){
                    content
                }
                // Getting How many tabs are there by getting the total Content Size...
                .overlay(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .global))
                    }
                )
                // When value Changes...
                .onPreferenceChange(TabPreferenceKey.self) { proxy in
                    let minX = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenBounds().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
                    // Getting Tab Offset...
                    let progress = minX / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    self.tabOffset = tabOffset
                    self.maxTabs = maxTabs
                }
            }
        }
        .padding(.top, 3)
    }
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .init()
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


