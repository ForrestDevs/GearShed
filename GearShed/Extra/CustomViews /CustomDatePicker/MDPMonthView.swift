//
//  MonthView.swift
//  Gear Shed
//
//  Created by Luke Forrest Gannon on 2021-11-14.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct MDPMonthView: View {
    @EnvironmentObject var monthDataModel: CustomDatePickerModel
        
    @State private var showMonthYearPicker = false
    @State private var testDate = Date()
    
    private func showPrevMonth() {
        withAnimation {
            monthDataModel.decrMonth()
            showMonthYearPicker = false
        }
    }
    
    private func showNextMonth() {
        withAnimation {
            monthDataModel.incrMonth()
            showMonthYearPicker = false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                MDPMonthYearPickerButton(isPresented: self.$showMonthYearPicker)
                Spacer()
                Button( action: {showPrevMonth()} ) {
                    Image(systemName: "chevron.left").font(.title2)
                }.padding()
                Button( action: {showNextMonth()} ) {
                    Image(systemName: "chevron.right").font(.title2)
                }.padding()
            }
            .padding(.leading, 18)
            
            GeometryReader { reader in
                if showMonthYearPicker {
                    MDPMonthYearPicker(date: monthDataModel.controlDate) { (month, year) in
                        self.monthDataModel.show(month: month, year: year)
                    }
                }
                else {
                    DPMonthView()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.theme.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.theme.green, lineWidth: 1)
        )
        .padding()
        .frame(width: 300, height: 300)
    }
}

/**
 * MDPMonthView is really the crux of the control. This displays everything and handles the interactions
 * and selections. MulitDatePicker is the public interface that sets up the model and this view.
 */
