//
//  PriceTextField.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-05-17.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct PriceTextField: View {
    @AppStorage("Currency_Unit", store: .standard) var currencyUnitSetting: String = "$"
    @State var inputError = false
    @State var editingComplete = false
    @State var alertText = ""
    @Binding var textValue: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Price in \(Prefs.shared.currencyUnitSetting)", text: $textValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .font(.subheadline)
                .keyboardType(.decimalPad)
                .onChange(of: textValue) { newValue in
                    handleUserInput(for: newValue)
                }
            if inputError {
                Text(alertText)
                    .font(.system(size: 12))
                    .foregroundColor(.theme.accent)
                    .lineLimit(nil)
            }
        }
    }
    
    func handleUserInput(for newValue: String) {
        let trimmedText = limitOunces(newValue)
        if trimmedText != newValue {
            textValue = trimmedText
            editingComplete = false
        } else {
            editingComplete ? (inputError = false) : (editingComplete = true)
        }
    }
    func limitOunces(_ newValue: String) -> String {
        let filteredText = newValue.replacingOccurrences(of: "[^0123456789.]", with: "", options: .regularExpression)
        var returnString = filteredText
        var numSet = CharacterSet()
        numSet.insert(charactersIn: "23456789")
        //var runCheck = true
        if filteredText != newValue {
            alertText = "Numeric values only."
            inputError = true
        }
        // Make sure our value is not empty before checking:
        guard filteredText.count != 0 else { return returnString }
        // If first value is a "." add a 0 infront of it
        if String(filteredText[0]) == "." {
            returnString = "0" + filteredText
        }
        // If first value is a 0 make sure only a decimal can come after, if any other number comes after remove the 0
        if String(filteredText[0]) == "0" {
            if filteredText.count > 1 {
                let secondChar = String(filteredText[1])
                let validSecondChar = secondChar.replacingOccurrences(of: "[^.]", with: "", options: .regularExpression)
                if secondChar != validSecondChar {
                    returnString = String(filteredText[1])
                    alertText = "Invalid entry."
                    inputError = true
                }
            }
        }
        // Make sure the value is not larger than 1,000,000
        if Double(filteredText) ?? 0 > 1000000 {
            returnString = "1000000"
            alertText = "Value to large"
            inputError = true
        }
        let checkDecimals = limitTwoDecimalPlaces(returnString)
        return checkDecimals
    }
    func limitTwoDecimalPlaces(_ newValue: String) -> String {
        let input = newValue
        if let indexOfFirstDecimal = input.firstIndex(of: ".") {
            let textThroughDecimal = input.prefix(through: indexOfFirstDecimal)
            let textAfterDecimal = input.suffix(from: indexOfFirstDecimal)
            let trimDecimals = textAfterDecimal.replacingOccurrences(of: ".", with: "")
            if trimDecimals.count > 2 {
                alertText = "Limit two decimal places."
                inputError = true
            }
            let trimDecimalPlaces = String(trimDecimals.prefix(2))
            return textThroughDecimal + trimDecimalPlaces
        }
        return input
    }
}
