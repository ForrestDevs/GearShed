//
//  ItemDiaryDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct ItemDiaryDetailView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @ObservedObject var diary: ItemDiary
    
    var body: some View {
        NavigationView {
            contentView
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                backButton
                viewTitle
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    private var contentView: some View {
        ZStack {
            Color.theme.silver
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading, spacing: 2) {
                    Text("\(diary.gearlist.startDate?.monthDayYearDateText() ?? "") | \(diary.gearlist.name)")
                        .formatItemNameBlack()
                        .frame(alignment: .center)
                        .padding()
                    
                    Text("\"\(diary.details)\"")
                        .formatDiaryDetails()
                        .frame(alignment: .center)
                        .padding()
                }
            }
        }
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text(diary.name)
                .formatGreen()
        }
    }
}

