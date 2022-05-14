//
//  GlobalPrefs.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-01-24.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import SwiftUI

class Prefs {
    @Published var confirmationAlert: Bool = false
    @AppStorage("pdfUserName", store: .standard) var pdfUserName: String = "Default Value"
    @AppStorage("Weight_Unit", store: .standard) var weightUnit: String = "g"
    @AppStorage("isDarkMode", store: .standard) var isDarkMode: Bool = false
    @AppStorage("isSystemMode", store: .standard) var isSystemMode: Bool = true
    @AppStorage("Currency_Unit", store: .standard) var currencyUnitSetting: String = "$"

    //MARK: Global Weight Conversion Functions
    func convertMetricToImp(grams: String) -> (lbs: String, oz: String) {
        let weight = Double(grams) ?? 0
        var totalOZ: Double {
            weight / 28.3495
        }
        var lbs: Int {
            let x = (totalOZ / 16)
            return Int(x.rounded(.towardZero))
        }
        var oz: Double {
            ( totalOZ - Double(lbs * 16) )
        }
        let StringLbs = String(lbs)
        let StringOz = String(format: "%.2f", oz)
        return (StringLbs, StringOz)
    }
    func convertImpToMetric(lbs: String, oz: String) -> String {
        //print("LBS as string \(lbs)")
        let IntPound = Int(lbs)
        //print("LBS as Int \(IntPound ?? 0)")
        let poundAsOunces = Double((IntPound ?? 0) * 16)
        //print(" total Ounces from pounds \(poundAsOunces) ")
        //print ("OZ as String \(oz)")
        let ozD: Double = Double(oz) ?? 0.0
        //print("Oz as Double \(ozD) ")
        var totalOZ: Double {
            poundAsOunces + ozD
        }
        //print("total Ounces \(totalOZ) ")
        var grams: Double {
            totalOZ * 28.3495
        }
        //print("grams \(grams)")
        let totalGrams = grams.rounded(.toNearestOrEven)
        //print("total grams rounded \(totalGrams)")
        let StringGram = String(format: "%.0f", totalGrams)
        //print(" string total grams \(StringGram) ")
        return StringGram
    }
    //MARK: Global Singleton
    class var shared: Prefs {
        struct Static {
            static let instance = Prefs()
        }
      
        return Static.instance
    }
}



