//
//  EmptyTripView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI




struct EmptyViewText: View {

    var text: String
    
    var body: some View {
        ZStack {
            Color.theme.silver
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text (text)
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


/*
 You have no \(emptyText). To \(verbText) a peice of gear, hold down on the gear row and press the '\(buttonName)'  button.
 """)
 
 struct EmptyViewText: View {
     
     var emptyText: String
     var buttonName: String?
     
     var body: some View {
         ZStack {
             Color.theme.silver
                 .edgesIgnoringSafeArea(.bottom)
             VStack {
                 Text ("""
                 You have no \(emptyText), please press the + button below to get started.
                 """)
                     .formatEmptyTitle()
                 Spacer()
             }
             .padding()
             .padding(.top, 50)
         }
         
     }
 }
 
 */
