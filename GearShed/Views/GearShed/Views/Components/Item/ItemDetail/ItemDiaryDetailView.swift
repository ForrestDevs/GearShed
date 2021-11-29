//
//  ItemDiaryDetailView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
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
                VStack (alignment: .leading, spacing: 2){
                    HStack {
                        Text("Gearlist:")
                        Text(diary.gearlist.name)
                    }
                    Text(diary.details)
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

