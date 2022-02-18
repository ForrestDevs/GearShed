//
//  GearListExportSheet.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-18.
//

import SwiftUI

struct GearListExportSheet: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @State var data: Data
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.05, alignment: .center)
                .offset(y: 30)
                .foregroundColor(Color.gray)
            ShareView(activityItems: [data])
        }
        .transition(.move(edge: .bottom))
    }
}


