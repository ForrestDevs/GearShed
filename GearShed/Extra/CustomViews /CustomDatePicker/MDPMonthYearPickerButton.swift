//
//  MonthYearPickerButton.swift
//  Gear Shed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct MDPMonthYearPickerButton: View {
    @EnvironmentObject var monthDataModel: CustomDatePickerModel
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button( action: {withAnimation { isPresented.toggle()} } ) {
            HStack {
                Text(monthDataModel.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent /*self.isPresented ? .accentColor : .black*/)
                Image(systemName: "chevron.right")
                    .rotationEffect(self.isPresented ? .degrees(90) : .degrees(0))
            }
        }
    }
}

/**
 * The MDPMonthYearPickerButton sits at the top of the MDPMonthView and displays the current month
 * and year showing in the view. Tapping this control switches the main view to the month/year
 * picker.
 *
 * This is a quick way for the user to jump the year or month without having to the < or >
 * buttons.
 */
