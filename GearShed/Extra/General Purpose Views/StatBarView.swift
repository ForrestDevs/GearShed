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
                        Text("\(viewModel.sheds.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                
                HStack {
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
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalWeight(array: viewModel.items)) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.totalCost(array: viewModel.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalFavs(array: viewModel.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Regrets")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.regretItems.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)

    }
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
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Cost")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.totalCost(array: viewModel.wishListItems))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)
    }
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
                        Text("\(viewModel.totalWeight(array: viewModel.favItems)) g")
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
                        Text("$ \(viewModel.totalCost(array: viewModel.favItems))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)
    }
}

struct StatBarInRegret: View {
    
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
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.regretItems.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalWeight(array: viewModel.regretItems)) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.totalCost(array: viewModel.regretItems))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)
    }
}

struct StatBarInShed: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    @ObservedObject var shed: Shed
    
    init(persistentStore: PersistentStore, shed: Shed) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.shed = shed
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(shed.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalWeight(array: shed.items)) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.totalCost(array: shed.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalFavs(array: shed.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Regrets")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalRegrets(array: shed.regretItems))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)
    }
}

struct StatBarInBrand: View {
    
    @EnvironmentObject var persistentStore: PersistentStore

    @StateObject private var viewModel: MainCatelogVM
    
    @ObservedObject var brand: Brand
    
    init(persistentStore: PersistentStore, brand: Brand) {
        let viewModel = MainCatelogVM(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.brand = brand
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 30){
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(brand.items.count)")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalWeight(array: brand.items)) g")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Invested")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("$ \(viewModel.totalCost(array: brand.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalFavs(array: brand.items))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Regrets")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                        Text("\(viewModel.totalRegrets(array: brand.regretItems))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .background(Color.theme.background)
    }
}
