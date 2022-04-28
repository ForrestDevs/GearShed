//
//  EmptyViewText.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct EmptyViewText: View {
    var text: String
    var body: some View {
        ZStack {
            Color.theme.silver
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Text (text)
                    .formatEmptyTitle()
                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }
    }
}
