//
//  AppTabBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AppTabBarView: View {
    
    @EnvironmentObject var persistentStore: PersistentStore
        
    @State var tabInt: Double = 0
    
    @State var offset: CGFloat = 0

    @State var tabOffset: CGFloat = 0

    var body: some View {
        ZStack {
            backgroundLayer
            tabLayer
            contentLayer
        }
    }
}

extension AppTabBarView {
    
    private var backgroundLayer: some View {
        Color.theme.background
            .ignoresSafeArea()
    }
    
    private var tabLayer: some View {
        VStack {
            Spacer()
            HStack (spacing: 50) {
                gearShedButton
                gearListButton
                //gearPlanButton
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
        }
        .edgesIgnoringSafeArea(.top)
        .padding(.bottom, 20)
        .background(Color.theme.green)
    }
    
    private var contentLayer: some View {
        VStack {
            PagerTabView1(selection: $tabInt, offset: $offset, tabOffset: $tabOffset) {
                
                NavigationView { GearShedView(persistentStore: persistentStore) }
                .navigationViewStyle(.stack)
                //.navigationViewStyle(.stack)
                    .pageView(ignoresSafeArea: true)
                
                NavigationView { GearlistView(persistentStore: persistentStore) }
                .navigationViewStyle(.stack)
                //.navigationViewStyle(.stack)
                    .pageView(ignoresSafeArea: true)
                
                /*NavigationView { ImageView1() }
                    .pageView(ignoresSafeArea: true)*/
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 60)
        .edgesIgnoringSafeArea(.top)
    }
    
    private var gearShedButton: some View {
        VStack (alignment: .center, spacing: 1) {
            Image(systemName: "house")
            Text("Gear Shed")
                .formatNoColorSmall()
        }
        .onTapGesture {
            let newOffset = CGFloat(0) * getScreenBounds().width
            self.offset = newOffset
        }
        .foregroundColor (
            (-1 <= tabInt && tabInt <= 0.30) ?  Color.white : Color.theme.accent
        )
    }

    private var gearListButton: some View {
        VStack (alignment: .center, spacing: 1) {
            Image(systemName: "list.bullet.rectangle")
            Text("Gear List")
                .formatNoColorSmall()
        }
        .onTapGesture {
            let newOffset = CGFloat(1) * getScreenBounds().width
            self.offset = newOffset
        }
        .foregroundColor (
            (0.31 <= tabInt && tabInt <= 1) ? Color.white : Color.theme.accent
        )

    }
    
    private var gearPlanButton: some View {
        VStack (alignment: .center, spacing: 0) {
            Text("Gear Plan")
                .formatNoColorSmall()
        }
        .onTapGesture {
            let newOffset = CGFloat(2) * getScreenBounds().width
            self.offset = newOffset
        }
        .foregroundColor (
            (0.50 <= tabInt && tabInt <= 1) ? Color.white : Color.black
        )

    }
    
}


// Specify the decimal place to round to using an enum
public enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
}

// Round to the specific decimal place
public func preciseRound(
    _ value: Double,
    precision: RoundingPrecision = .ones) -> Double
{
    switch precision {
    case .ones:
        return round(value)
    case .tenths:
        return round(value * 10) / 10.0
    case .hundredths:
        return round(value * 100) / 100.0
    }
}
