//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

struct StatBar: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Sheds")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.categories.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                
                HStack {
                   //Rectangle()
                   //    .frame(width: 2, height: 40)
                   //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)

    }
    
    /*func totalWeight() -> String {
        
        let totalWeight: String = ""
        
        var totalWeightNum: Int = 0
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let x = nf.number(from: "1,234")?.intValue
        
        for item in viewModel.allItemsInShed {
            item.weight
        }
        
       return totalWeight
    }*/
    
    
}

struct StatBarInWishList: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                   //Rectangle()
                   //    .frame(width: 2, height: 40)
                   //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.wishListItems.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Cost")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)

    }
    
    /*func totalWeight() -> String {
        
        let totalWeight: String = ""
        
        var totalWeightNum: Int = 0
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let x = nf.number(from: "1,234")?.intValue
        
        for item in viewModel.allItemsInShed {
            item.weight
        }
        
       return totalWeight
    }*/
    
    
}

struct StatBarInFav: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                   //Rectangle()
                   //    .frame(width: 2, height: 40)
                   //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.favItems.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)

    }
    
    /*func totalWeight() -> String {
        
        let totalWeight: String = ""
        
        var totalWeightNum: Int = 0
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let x = nf.number(from: "1,234")?.intValue
        
        for item in viewModel.allItemsInShed {
            item.weight
        }
        
       return totalWeight
    }*/
    
    
}

struct StatBarInShed: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    init(persistentStore: PersistentStore) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                   //Rectangle()
                   //    .frame(width: 2, height: 40)
                   //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    //Rectangle()
                    //    .frame(width: 2, height: 40)
                    //    .foregroundColor(Color.theme.accent)
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)

    }
    
    /*func totalWeight() -> String {
        
        let totalWeight: String = ""
        
        var totalWeightNum: Int = 0
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let x = nf.number(from: "1,234")?.intValue
        
        for item in viewModel.allItemsInShed {
            item.weight
        }
        
       return totalWeight
    }*/
    
    
}
