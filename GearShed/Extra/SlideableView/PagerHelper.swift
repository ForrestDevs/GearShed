//
//  PagerHelper.swift
//  PagerHelper
//
//  Created by Balaji on 26/08/21.
//

import SwiftUI

// Custom View Builder...

struct PagerTabView<Content: View,Label: View>: View {
    
    var content: Content
    var label: Label
    // Tint...
    var tint: Color
    // Selection...
    @Binding var selection: Int
    
    init(tint: Color,selection: Binding<Int>,@ViewBuilder labels: @escaping ()->Label,@ViewBuilder content: @escaping ()->Content){
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
        VStack(spacing: 0){            
            HStack(spacing: 0) {
                label
            }
                // For Tap to change tab...
            .overlay(
                HStack(spacing: 0){
                        ForEach(0..<Int(maxTabs),id: \.self){index in
                            Rectangle()
                                .fill(Color.black.opacity(0.01))
                                .onTapGesture {
                                    // Changing Offset...
                                    // Based on Index...
                                    let newOffset = CGFloat(index) * getScreenBounds().width
                                    self.offset = newOffset
                                }
                        }
                    }
                )
                .foregroundColor(tint)
                
                // Indicator...
                Capsule()
                    .fill(tint)
                    .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 3)
                    .padding(.top,5)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .offset(x: tabOffset)
            
            
            
            
            OffsetPageTabView(selection: $selection,offset: $offset) {
                
                HStack(spacing: 0){
                    content
                }
                // Getting How many tabs are there by getting the total Content Size...
                .overlay(
                    GeometryReader{proxy in
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
    }
}

struct PagerTabView1<Content: View>: View {
    
    var content: Content
    
    @Binding var selection: Double
    
    @Binding var offset: CGFloat
    
    @Binding var tabOffset: CGFloat
    
    init(selection: Binding<Double>, offset: Binding<CGFloat>, tabOffset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._selection = selection
        self._offset = offset
        self._tabOffset = tabOffset
    }
    
    var body: some View {
        VStack(spacing: 0){
            OffsetPageTabView1(selection: $selection,offset: $offset) {
                
                HStack(spacing: 0){
                    content
                }
                // Getting How many tabs are there by getting the total Content Size...
                .overlay(
                    GeometryReader{proxy in
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
                }
            }
        }
    }
}

struct OffsetPageTabView1<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGFloat
    @Binding var selection: Double
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView1.Coordinator(parent: self)
    }
    
    init(selection: Binding<Double>,offset: Binding<CGFloat>,@ViewBuilder content: @escaping ()->Content){
        
        self.content = content()
        self._offset = offset
        self._selection = selection
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollview = UIScrollView()
        
        // Extracting SwiftUI View and embedding into UIKit ScrollView...
        let hostview = UIHostingController(rootView: content)
        hostview.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
        
            hostview.view.topAnchor.constraint(equalTo: scrollview.topAnchor),
            hostview.view.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            hostview.view.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            hostview.view.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            
            // if you are using vertical Paging...
            // then dont declare height constraint...
            hostview.view.heightAnchor.constraint(equalTo: scrollview.heightAnchor)
        ]
        
        scrollview.addSubview(hostview.view)
        scrollview.addConstraints(constraints)
        
        // ENabling Paging...
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        
        // setting Delegate...
        scrollview.delegate = context.coordinator
        
        return scrollview
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // need to update only when offset changed manually...
        // just check the current and scrollview offsets...
        let currentOffset = uiView.contentOffset.x
        
        if currentOffset != offset{
        
            print("updating")
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    // Pager Offset...
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: OffsetPageTabView1
        
        init(parent: OffsetPageTabView1) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            // Safer side updating selection on scroll....
            let maxSize = scrollView.contentSize.width
            let currentSelection = (offset / maxSize)
            let tabSelect = preciseRound(currentSelection, precision: .hundredths)
            parent.selection = Double(tabSelect)
            print("\(tabSelect)")
            parent.offset = offset
        }
    }
}


// Geometry Preference...
struct TabPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .init()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// Extending View for PageLabel and PageView Modifiers....
extension View {
    
    func pageLabel()->some View{
        // Just Filling all Empty Space...
        self
            .frame(maxWidth: .infinity,alignment: .center)
    }
    
    // Modifications for SafeArea Ignoring...
    // Same For PageView...
    func pageView(ignoresSafeArea: Bool = false,edges: Edge.Set = [])->some View{
        // Just Filling all Empty Space...
        self
            .frame(width: getScreenBounds().width,alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
    
    // Getting SCreen Bounds...
    func getScreenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
