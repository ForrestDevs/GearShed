//
//  CurrencyUnitView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-05-13.
//

import SwiftUI
import Combine

struct CurrencyUnitName: Identifiable {
    var id: UUID = UUID()
    var symbol: String
    var name: String
}

class CurrencyUnitNameVM: ObservableObject {
    @Published var results: [CurrencyUnitName] = []
    func updateResults(using tuples: [(String, String)]) {
        let newResults = tuples.map({
            CurrencyUnitName.init(symbol: $0.0, name: $0.1)
        })
        results = newResults
    }
}

struct CurrencyUnitView: View {
    @AppStorage("Currency_Unit", store: .standard) var currencyUnitSetting: String = "$"
    @StateObject private var model: CurrencyUnitNameVM = CurrencyUnitNameVM()
    let currencyList: [(String, String)] = [
        ("$", "Dollar"), ("€", "Euro"), ("£", "Pound"),
        ("¥","Yen"), ("₣","Franc"), ("₱","Peso"), ("₽","Rruble"),
        ("₹","Rupee"), ("₺","Lira"), ("֏","Dram"), ("₭", "Kip"),
        ("฿","Baht"), ("₲","Guarani"), ("₦","Naira"), ("₩","Won"),
        ("₸","Tenge"), ("₵","Cedi"), ("₾","Lari"), ("₡","Colon"),
        ("₼","Manat"), ("Ar", "Ariaya"), ("Br","Birr"), ("Bs.","Boliviano"),
        ("c", "Som"), ("D","Dalasi"), ("G","Gourde"), ("K","Kina"),
        ("Kz","Kwanza"), ("kr","krona"), ("kn","Kuna"),
        ("L","Lempira"), ("L", "Lek"), ("Le","Leon"), ("lei","Leu"),
        ("MK", "Kwacha"), ("MT","Metical"), ("m.","Manat"),
        ("Nu.","Ngultrum"), ("P","Pula"), ("Q","Quetzal"), ("R","Rand"),
        ("RM", "Ringgit"), ("Rp", "Rupiah"), ("S/.","Sol"),
        ("Sh","Shiling"), ("UM","Ouguiya"), ("Vt","Vatu"), ("ZK","Kwacha")
    ]
    var body: some View {
        List {
            ForEach(model.results, id:\.id) { currency in
                Button {
                    currencyUnitSetting = currency.symbol
                } label: {
                    HStack {
                        Text("\(currency.symbol) - ")
                        Text(currency.name)
                        if currencyUnitSetting == currency.symbol {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                 
             }
        }
        .onAppear(perform: {
           model.updateResults(using: currencyList)
        })
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Change App Icon", displayMode: .inline)
    }
}


//        HStack {
//            Text("Weight Unit:")
//            Button {
//                toggleWeightUnit()
//            } label: {
//                HStack {
//                    Text("g")
//                        .foregroundColor(weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
//                        .padding(.leading, 10)
//                    Image(systemName: "checkmark")
//                        .foregroundColor(weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
//                        .opacity(Prefs.shared.weightUnit == "g" ? 1 : 0)
//                        .padding(.trailing, 5)
//
//                    Text("lbs + oz")
//                        .foregroundColor(weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
//                    Image(systemName: "checkmark")
//                        .foregroundColor(weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
//                        .opacity(weightUnit == "lb + oz" ? 1 : 0)
//                }
//            }
//        }
