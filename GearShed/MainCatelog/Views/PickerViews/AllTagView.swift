//
//  AllTagView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AllTagView: View {
    @StateObject private var viewModel = MainCatelogVM()

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.allTags) { tag in
                    TagRowView(rowData: TagRowData(tag: tag))
                        .padding(.top, 10)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .opacity(0)
            Spacer(minLength: 50)
        }
    }
}

struct AllTagView_Previews: PreviewProvider {
    static var previews: some View {
        AllTagView()
    }
}
