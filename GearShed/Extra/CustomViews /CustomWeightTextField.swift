//
//  CustomWeightTextField.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//

import SwiftUI

struct WeightTextField: View {
    @State var inputError = false
    @State var editingComplete = false
    @State var alertText = ""
    @Binding var textValueGrams: String
    @Binding var textValueLbs: String
    @Binding var textValueOz: String
    
    enum TextType {
        case grams, lbs, oz
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (Prefs.shared.weightUnit == "g") {
                TextField("Weight in g", text: $textValueGrams)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .font(.subheadline)
                    .keyboardType(.numberPad)
                    .onChange(of: textValueGrams) { newValue in
                        handleUserInput(for: newValue, type: TextType.grams)
                    }
            }
            if (Prefs.shared.weightUnit == "lb + oz") {
                HStack (spacing: 10) {
                    TextField("lb", text: $textValueLbs)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .font(.subheadline)
                        .keyboardType(.numberPad)
                        .onChange(of: textValueLbs) { newValue in
                            handleUserInput(for: newValue, type: TextType.lbs)
                        }
                    
                    TextField("oz", text: $textValueOz)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .font(.subheadline)
                        .keyboardType(.decimalPad)
                        .onChange(of: textValueOz) { newValue in
                            handleUserInput(for: newValue, type: TextType.oz)
                        }
                }
            }
            if inputError {
                Text(alertText)
                    .font(.system(size: 12))
                    .foregroundColor(.theme.accent)
                    .lineLimit(nil)
            }
        }
    }
    
    func handleUserInput(for newValue: String, type: TextType) {
        switch type {
        case .grams:
            let trimmedText = limitWholeNumber(newValue)
            if trimmedText != newValue {
                textValueGrams = trimmedText
                editingComplete = false
            } else {
                editingComplete ? (inputError = false) : (editingComplete = true)
            }
        case .lbs:
            let trimmedText = limitWholeNumber(newValue)
            if trimmedText != newValue {
                textValueLbs = trimmedText
                editingComplete = false
            } else {
                editingComplete ? (inputError = false) : (editingComplete = true)
            }
        case .oz:
            let trimmedText = limitOunces(newValue)
            if trimmedText != newValue {
                textValueOz = trimmedText
                editingComplete = false
            } else {
                editingComplete ? (inputError = false) : (editingComplete = true)
            }
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
        // If first number is a 1 make sure second number can only be 0-5
        if String(filteredText[0]) == "1" {
            if filteredText.count > 1 {
                let secondChar = String(filteredText[1])
                let validSecondChar = secondChar.replacingOccurrences(of: "[^012345.]", with: "", options: .regularExpression)
                if secondChar != validSecondChar {
                    returnString = String(filteredText[0])
                    alertText = "Ounces cannot be 16 or more."
                    inputError = true
                }
            }
        }
        // Check to see if first number is 2-9, if so second number cannot be anything but a "."
        if String(filteredText[0]).rangeOfCharacter(from: numSet) != nil {
            if filteredText.count > 1 {
                let secondChar = String(filteredText[1])
                let validSecondChar = secondChar.replacingOccurrences(of: "[^.]", with: "", options: .regularExpression)
                if secondChar != validSecondChar {
                    returnString = String(filteredText[0])
                    alertText = "Ounces cannot be 16 or more."
                    inputError = true
                }
            }
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
    func limitWholeNumber(_ newValue: String) -> String {
        let filteredInput = newValue.replacingOccurrences(of: "[^0123456789]", with: "", options: .regularExpression)
        var returnedValue: String = filteredInput
        if returnedValue != newValue {
            alertText = "Whole numbers only"
            inputError = true
        }
        if returnedValue.count > 7 {
            returnedValue = String(returnedValue.prefix(7))
            alertText = "Value to large"
            inputError = true
        }
        return returnedValue
    }
}
