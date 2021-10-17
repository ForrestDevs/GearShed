//
//  SimpleHeaderView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

struct SimpleHeaderView: View {

    var label: String
    
    @Binding var expanded: Bool
    
	var body: some View {
		VStack(spacing: 2) {
			HStack {
				Text(label)
					.font(.headline)
                    .foregroundColor(Color.theme.accent)
					.padding([.leading], 20)
				Spacer()
                
                Button {self.expanded.toggle()}
                    label: {
                        Image(systemName: "chevron.up")
                            .rotationEffect(Angle(degrees: expanded ? 180 : 0))
                    }
                
			}
			Rectangle()
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
		}
	}
}


