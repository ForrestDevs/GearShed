//
//  HomeView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var index = "Home"
    @State var show = false
    
    var body: some View {
        
        ZStack{
            
            // Create the viewcontainer outline
            (self.show ? Color.black.opacity(0.05) : Color.clear).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .leading) {
                
                VStack(alignment : .leading, spacing: 25) {
                    
                    // UserProfile
                    HStack(spacing: 15){
                        
                        Image("acc")
                        .resizable()
                        .frame(width: 65, height: 65)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Luke")
                                .fontWeight(.bold)
                            
                            Text("Toronto , CA")
                        }
                    }
                    //.padding(.top, 50)

                    // Side Tab Items
                    NavigationLink(destination: PreferencesTabView()) { Text("Settings") }
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.top)
                .scaleEffect(self.show ? 1 : 0)
                 
                MainView1(show: self.$show,index: self.$index)
                //.scaleEffect(self.show ? 0.8 : 1)
                .offset(x: self.show ? 250 : 0)//, y : self.show ? 50 : 0)
                .disabled(self.show ? true : false)
                .onTapGesture {
                    if show {
                        withAnimation(.spring()) {
                            self.show.toggle()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct MainView1 : View {
    
    @Binding var show : Bool
    @Binding var index : String
    
    var body : some View{
        
        VStack(spacing: 0) {
            
            // TopBar
            HStack{
                
                // Button To Open SideTab
                Button(action: {
                    withAnimation(.spring()) {
                        self.show.toggle()
                    }
                }) {
                    Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(Color.theme.green)
                }
                
                Spacer()
               
                Text("Home")
                    .fontWeight(.bold)
                    .font(.title)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.theme.background)
            .padding(.bottom, 10)
            
            // Content
            ScrollView {
                
                ForEach(1..<10) { item in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                        .frame(width: 350, height: 100)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background(Color.theme.background)
        //.cornerRadius(15)
    }
}

struct MainView2 : View {
    
    @Binding var show : Bool
    @Binding var index : String
    
    var body : some View {
        
        // Content
        ScrollView {
            ForEach(1..<10) { item in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                    .frame(width: 350, height: 100)
            }
        }
            .navigationBarTitle("Home", displayMode: .inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading, content: button) }
            .background(Color.theme.background)
            //.cornerRadius(15)
    }
    
    // Button
    private func button() -> some View {
        Button(action: {
            withAnimation(.spring()) {
                self.show.toggle()
            }
        }) {
            Image(systemName: "list.bullet")
            .resizable()
            .frame(width: 20, height: 15)
            .foregroundColor(Color.theme.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView1(show: .constant(false),index: .constant(""))
    }
}
