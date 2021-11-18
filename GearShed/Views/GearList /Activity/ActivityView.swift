//
//  ActivityView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import SwiftUI

struct ActivityView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var viewModel: GearlistData
    
    @EnvironmentObject private var detailManager: DetailViewManager
    
    var body: some View {
        VStack (spacing: 0) {
            statBar
            Spacer()
            ZStack {
                activitiesList
                addListButtonOverlay
            }
        }
    }
}

extension ActivityView {
    
    private var statBar: some View {
        HStack (spacing: 20){
            HStack {
                Text("Items:")
                //Text("\(gsData.items.count)")
            }
            HStack {
                Text("Weight:")
                //Text("\(gsData.totalWeight(array: gsData.items))g")
            }
            HStack {
                Text("Invested:")
                //Text("$\(gsData.totalCost(array: gsData.items))")
            }
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }

    private var activitiesList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack (alignment: .leading, spacing: 5) {
                ForEach(viewModel.activities) { activity in
                    GearlistRowView(gearlist: activity)
                        .padding(.top, 15)
                }
            }
        }
    }
    
    private var addListButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        detailManager.content = AnyView (
                            AddActivityView(persistentStore: persistentStore)
                            .environmentObject(detailManager)
                            .environmentObject(viewModel)
                        )
                        detailManager.showContent = true
                    }
                }
                label: {
                    VStack{
                        Text("Add")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                            
                        Text("List")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.theme.background)
                    }
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
}




