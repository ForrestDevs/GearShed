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
            ZStack {
                Color.theme.offWhite
                Text("Diary Details")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                backButton
                viewTitle
            }
            
        }
        .transition(.move(edge: .trailing))
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.showItemDiaryDetail = false
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
    
    private var editButton: some ToolbarContent {
        ToolbarItem (placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    detailManager.showModifyItemDiary = true
                }
            } label: {
                Text("Edit")
            }
        }
    }
    
}

