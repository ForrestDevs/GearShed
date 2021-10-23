//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct StatBar1: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Weight")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count) g")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Trips")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Acquired")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Investment")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("$\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }
}



struct StatBar: View {
    
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Items")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Weight")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Investment")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 2, height: 40)
                        .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Favourites")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.allItemsInShed.count)")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }

    }
    
    func totalWeight() -> String {
        
        let totalWeight: String = ""
        
        var totalWeightNum: Int = 0
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let x = nf.number(from: "1,234")?.intValue
        
        for item in viewModel.allItemsInShed {
            item.weight
        }
        
       return totalWeight
    }
}
