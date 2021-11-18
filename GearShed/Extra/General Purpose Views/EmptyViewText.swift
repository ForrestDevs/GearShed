//
//  EmptyTripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI


struct EmptyViewText: View {
    
    var emptyText: String
    var buttonName: String
    
    var body: some View {
        ZStack {
            Color.theme.offWhite
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text ("""
                You have no \(emptyText), please click the \(buttonName) button below to get started.
                """)
                    .formatEmptyTitle()
                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }
        
    }
}

struct EmptyViewTextNonButton: View {
    
    var emptyText: String
    var buttonName: String
    
    var body: some View {
        ZStack {
            Color.theme.offWhite
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text ("""
                You have no \(emptyText). To \(buttonName) an Item, hold down on an Item and choose the \(buttonName) Item button.
                """)
                    .formatEmptyTitle()
                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }
        
    }
}

// this consolidates the code for what to show when a list is empty
struct EmptyTripView: View {
    var body: some View {
        VStack {
            /*Group {
                Text("You have")
                    .padding([.top], 200)
                Text("no trips.")
            }
            .font(.title)
            .foregroundColor(.secondary)
            Spacer()*/
        }
    }
}

struct EmptyTripView_Previews: PreviewProvider {
    static var previews: some View {
            EmptyTripView()
    }
}
