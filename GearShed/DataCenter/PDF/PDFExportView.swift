//
//  PDFExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-30.
//

import SwiftUI
import UIKit
import PDFCreator

enum PDFType: String, CaseIterable {
    case shed, brand, fav, wish, regret
}

struct pdfItem {
    var name: String
    var brand: String
    var shed: String
    var weight: String
    var lbs: String
    var oz: String
    var price: String
    var details: String
}

struct CaseIterablePicker<T: CaseIterable & Hashable> : View
  where T.AllCases: RandomAccessCollection {

  var title: String = ""
  var selection: Binding<T>
  var display: (T) -> String = { "\($0)" }

  var body: some View {
    Picker(title, selection: selection) {
      ForEach(T.allCases, id:\.self) {
        Text(display($0)).tag($0)
      }
    }
    .pickerStyle(.segmented)
  }
}

struct PDFExportView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var pdfType: PDFType = .shed
    
    @State private var showShareSheet : Bool = false
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            CaseIterablePicker(title: "", selection: $pdfType, display: \.rawValue.capitalized)
            switch pdfType {
            case .shed:
                PDFPreviews(data: createPDF())
            case .brand:
                PDFPreviews(data: createPDF())
            case .fav:
                PDFPreviews(data: createPDF())
            case .wish:
                PDFPreviews(data: createPDF())
            case .regret:
                PDFPreviews(data: createPDF())
            }
        }
        .navigationBarTitle("Share Gear Shed", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { exportButton() }
            ToolbarItem(placement: .navigationBarLeading) { cancelButton() }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = createPDF() {
                ShareView(activityItems: [data])
            }
        }
    }
        
    
    func shedCount() -> String {
        let count = viewModel.sheds.count
        return String(count)
    }
    
    func gearCount() -> String {
        let count = viewModel.items.count
        return String(count)
    }
    
    func costCount() -> String {
        let value = viewModel.totalCost(array: viewModel.items)
        return value
    }
    
    func weightCount(array: [Item]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = viewModel.totalGrams(array: array)
        } else {
            let lbOz = viewModel.totalLbsOz(array: array)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            value = "\(lb) Lbs + \(oz) Oz"
        }
        return value
    }
    
    func weightCount(pdfItems: [pdfItem]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(totalGrams(array: pdfItems)) g"
        } else {
            let lbOz = totalLbsOz(array: pdfItems)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            value = "\(lb) Lbs \(oz) Oz"
        }
        return value
    }
    
    func totalGrams(array: [pdfItem]) -> String {
        var arrayString = [String]()
        for x in array {
            arrayString.append(x.weight)
        }
        let intArray = arrayString.map { Int($0) ?? 0 }
        let total = intArray.reduce(0, +)
        let totalString = String(total)
        return totalString
    }
    
    func itemWeightUnit(item: pdfItem) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(item.weight) g"
        } else {
            let lbs = item.lbs
            let oz = item.oz
            value = "\(lbs) Lbs \(oz) Oz"
        }
        return value
    }
    
    func totalLbsOz(array: [pdfItem]) -> (lbs: String, oz: String) {
        // Taking the intial array of items and mapping the corrosponding mass value while reducing to set a total mass value from the array
        let totalLbs = array.map { Int($0.lbs) ?? 0 }.reduce(0, +)
        let totalOz = array.map { Double($0.oz) ?? 0.0 }.reduce(0, +)
        // Doing nessecary math to make sure every 16 ounces gets counted as a pound and then convert final totals of mass units to strings
        let totalLbsString = String(totalLbs + Int((totalOz / 16).rounded(.towardZero)))
        let totalOzString = String(format: "%.2f", totalOz - Double(Int((totalOz / 16).rounded(.towardZero)) * 16))
        return (totalLbsString, totalOzString)
    }
    
    func statTitleWeightSetting() -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "Weight (g)"
        } else {
            value = "Weight (Lbs/Oz)"
        }
        return value
    }
    
    func statTitleTextBold(text: String ) -> PDFAttributedText {
        let attributedTitle = NSMutableAttributedString(string: "\(text)", attributes: [
            .font: UIFont(name: "HelveticaNeueBold", size: 11)!
        ])
        let title = PDFAttributedText(text: attributedTitle)
        return title
    }
    
    func statText(text: String ) -> PDFAttributedText {
        let attributedTitle = NSMutableAttributedString(string: "\(text)", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: 11)!
        ])
        let title = PDFAttributedText(text: attributedTitle)
        return title
    }
    
    func sectionHeaderTitle(name: String, array: [pdfItem]) -> PDFAttributedText {
        let attributedTitle = NSMutableAttributedString(string: " \(name) \(weightCount(pdfItems: array))", attributes: [
            .font: UIFont(name: "HelveticaNeueBold", size: 11)!
        ])
        let title = PDFAttributedText(text: attributedTitle)
        return title
    }
    
    func titleLineOne() -> PDFAttributedText {
        let attributedTitleLineOne = NSMutableAttributedString(string: "\(Prefs.shared.pdfUserName)'s GEAR SHED", attributes: [
            .font: Font.custom("HelveticaNeue", size: 11)
        ])
        let title = PDFAttributedText(text: attributedTitleLineOne)
        return title
    }
    
    func titleLineTwo() -> PDFAttributedText {
        var text: String = ""
        
        switch pdfType {
        case .shed:
            text = "Shed"
        case .brand:
            text = "Brand"
        case .fav:
            text = "Fav"
        case .wish:
            text = "Wish"
        case .regret:
            text = "Regret"
        }
        
        let attributedTitle = NSMutableAttributedString(string: "\(text) View | \(Date().monthDayYearDateText())", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: 11)!
        ])
        let title = PDFAttributedText(text: attributedTitle)
        return title
    }
    
    func createPDF() -> Data {
        var shelves = [String]()
        var brands = [String]()
        var items = [pdfItem]()
        var favItems = [pdfItem]()
        var wishItems = [pdfItem]()
        var regretItems = [pdfItem]()
        for item in viewModel.items {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail)
            items.append(newItem)
        }
        for item in viewModel.favItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail)
            favItems.append(newItem)
        }
        for item in viewModel.wishListItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail)
            wishItems.append(newItem)
        }
        for item in viewModel.regretItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail)
            regretItems.append(newItem)
        }
        for shed in viewModel.sheds {
            shelves.append(shed.name)
        }
        for brand in viewModel.brands {
            brands.append(brand.name)
        }
        
        
        // MARK: Create PDF and Size
        let document = PDFDocument(format: .a4)
        
        // MARK: Add Elements to PDF
        let logo = PDFImage(image: Image(named: "PDFLogo")!, size: CGSize(width: 125, height: 125))
        document.add(.contentCenter, image: logo)
        
        document.add(space: 10)
        document.add(.contentLeft, attributedTextObject: titleLineOne())
        document.add(.contentLeft, attributedTextObject: titleLineTwo())
        document.add(space: 15)
        
        let statTable = PDFTable(rows: 2, columns: 4)
        statTable.content = [
            ["Shed (#)", "Gear (#)", statTitleWeightSetting(), "Invested ($)"],
            [shedCount(), gearCount(), weightCount(array: viewModel.items), costCount()]
        ]
        statTable.rows.allCellsStyle = PDFTableCellStyle.none
        
        let firstRow = statTable[rows: 0..<1]
        let firstRowStyle = PDFTableCellStyle(font: Font(name: "HelveticaNeue", size: 11)!)
        firstRow.allCellsStyle = firstRowStyle
        
        let secondRow = statTable[rows: 1..<2]
        let secondRowStyle = PDFTableCellStyle(font: Font(name: "HelveticaNeue", size: 11)!)
        secondRow.allCellsStyle = secondRowStyle
        
        statTable.rows.allCellsAlignment = .left
        // Set table padding and margin
        statTable.padding = 2
        statTable.margin = 0
        
        document.add(table: statTable)
        document.add(space: 15)
        
        switch pdfType {
        case .shed:
            shelves.forEach { shelf in
                let shelf = shelf
                let items = items.filter { $0.shed == shelf }
                let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
                let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
                
                let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
                sectionGroup.set(indentation: 0.0, left: true)
                sectionGroup.addLineSeparator(style: lineStyle)
                sectionGroup.add(space: 3)
                sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
                sectionGroup.add(space: 3)
                sectionGroup.addLineSeparator(style: lineStyle)
                document.add(group: sectionGroup)
                
                document.add(space: 10)
                items.forEach { item in
                    let itemGroup = PDFGroup(allowsBreaks: false)
                    itemGroup.set(indentation: 15, left: true)
                    itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
                    itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
                    itemGroup.add(attributedTextObject: statText(text: item.details))
                    document.add(group: itemGroup)
                    document.add(space: 10)
                }
            }
        case .brand:
            brands.forEach { brand in
                let brand = brand
                let items = items.filter { $0.brand == brand }
                let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
                let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
                
                let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
                sectionGroup.set(indentation: 0.0, left: true)
                sectionGroup.addLineSeparator(style: lineStyle)
                sectionGroup.add(space: 3)
                sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: brand, array: items))
                sectionGroup.add(space: 3)
                sectionGroup.addLineSeparator(style: lineStyle)
                document.add(group: sectionGroup)
                
                document.add(space: 10)
                items.forEach { item in
                    let itemGroup = PDFGroup(allowsBreaks: false)
                    itemGroup.set(indentation: 15, left: true)
                    itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.shed))
                    itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
                    itemGroup.add(attributedTextObject: statText(text: item.details))
                    document.add(group: itemGroup)
                    document.add(space: 10)
                }
            }
        case .fav:
            shelves.forEach { shelf in
                let shelf = shelf
                let items = favItems.filter { $0.shed == shelf }
                let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
                let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
                
                let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
                sectionGroup.set(indentation: 0.0, left: true)
                sectionGroup.addLineSeparator(style: lineStyle)
                sectionGroup.add(space: 3)
                sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
                sectionGroup.add(space: 3)
                sectionGroup.addLineSeparator(style: lineStyle)
                document.add(group: sectionGroup)
                
                document.add(space: 10)
                items.forEach { item in
                    let itemGroup = PDFGroup(allowsBreaks: false)
                    itemGroup.set(indentation: 15, left: true)
                    itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
                    itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
                    itemGroup.add(attributedTextObject: statText(text: item.details))
                    document.add(group: itemGroup)
                    document.add(space: 10)
                }
            }
        case .wish:
            shelves.forEach { shelf in
                let shelf = shelf
                let items = wishItems.filter { $0.shed == shelf }
                let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
                let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
                
                let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
                sectionGroup.set(indentation: 0.0, left: true)
                sectionGroup.addLineSeparator(style: lineStyle)
                sectionGroup.add(space: 3)
                sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
                sectionGroup.add(space: 3)
                sectionGroup.addLineSeparator(style: lineStyle)
                document.add(group: sectionGroup)
                
                document.add(space: 10)
                items.forEach { item in
                    let itemGroup = PDFGroup(allowsBreaks: false)
                    itemGroup.set(indentation: 15, left: true)
                    itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
                    itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
                    itemGroup.add(attributedTextObject: statText(text: item.details))
                    document.add(group: itemGroup)
                    document.add(space: 10)
                }
            }
        case .regret:
            shelves.forEach { shelf in
                let shelf = shelf
                let items = regretItems.filter { $0.shed == shelf }
                let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
                let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
                
                let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
                sectionGroup.set(indentation: 0.0, left: true)
                sectionGroup.addLineSeparator(style: lineStyle)
                sectionGroup.add(space: 3)
                sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
                sectionGroup.add(space: 3)
                sectionGroup.addLineSeparator(style: lineStyle)
                document.add(group: sectionGroup)
                
                document.add(space: 10)
                items.forEach { item in
                    let itemGroup = PDFGroup(allowsBreaks: false)
                    itemGroup.set(indentation: 15, left: true)
                    itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
                    itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
                    itemGroup.add(attributedTextObject: statText(text: item.details))
                    document.add(group: itemGroup)
                    document.add(space: 10)
                }
            }
        }
        
        // MARK: Generate and return PDF Data
        let generator = PDFGenerator(document: document)
        let pdf = try! generator.generateData()
        return pdf
    }
    
    func pdfData() -> Data? {
        var tableData = [TableData]()
        
        for item in viewModel.items {
            tableData.append(TableData(name: item.name, detail: item.detail, brand: item.brandName, shed: item.shedName, price: item.price, weight: item.weight))
        }
        
        let tableDataHeaderTitles =  ["name", "details", "brand", "shed", "price", "weight"]
        
        let pdfCreator = PDFCreator(tableDataItems: tableData, tableDataHeaderTitles: tableDataHeaderTitles)
        
        let data = pdfCreator.create()
        
        return data
    }
    
    private func cancelButton() -> some View {
        Button("Cancel",action: {presentationMode.wrappedValue.dismiss()})
    }
    
    private func exportButton() -> some View {
        Button("Export",action: {showShareSheet.toggle()})
    }
}






/*let section = PDFSection(columnWidths: [0.25, 0.75])
let leftSection = section.columns[0]
leftSection.add(image: logo)
let rightSection = section.columns[1]
rightSection.add(text: "\(Prefs.shared.pdfUserName)'s GEAR SHED")
rightSection.add(text: "\(viewType) View | Nov 28, 2021")
rightSection.add(space: 10)
document.add(section: section)
document.add(space: 10)
 
 
 statTable.content = [
     ["Shed (#)", "Gear (#)", "Weight (g)", "Invested ($)"],
     [shedCount(), gearCount(), weightCount(), costCount()]
 ]
 
 statTable.rows.allCellsStyle = PDFTableCellStyle.none
 
 /*do {
     try cell00.content = PDFTableContent(content: statTitleTextBold(text: "Shed (#)"))
     try cell01.content = PDFTableContent(content: statTitleTextBold(text: "Gear (#)"))
     try cell02.content = PDFTableContent(content: statTitleTextBold(text: "Weight (g)"))
     try cell03.content = PDFTableContent(content: statTitleTextBold(text: "Invested ($)"))
     
     try cell10.content = PDFTableContent(content: shedCount())
     try cell11.content = PDFTableContent(content: gearCount())
     try cell12.content = PDFTableContent(content: weightCount())
     try cell13.content = PDFTableContent(content: costCount())
 } catch {
     print(error)
 }*/
 
 
 /*func createPDF() -> Data {
     let document = PDFDocument(format: .a4)
     document.add(.contentCenter, text: "Create PDF documents easily.")
     let generator = PDFGenerator(document: document)
     let pdf = try! generator.generateData()
     return pdf
 }*/
 
 
 /*document.set(indent: 0.0, left: true)
 document.addLineSeparator(style: lineStyle)
 document.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
 document.addLineSeparator(style: lineStyle)*/
 
 EnumPicker(selected: $pdfType, title: )
 Picker("PDF Type", selection: $pdfType) {
     pdfType = .shed
     Text("Shed")
     Text("Brand").tag(1)
     Text("Fav").tag(2)
     Text("Wish").tag(3)
     Text("Regret").tag(4)
 }
 .pickerStyle(.segmented)
 
 let attributedTitleLineTwo = NSMutableAttributedString(string: "\(viewType) View | Nov 28, 2021", attributes: [
     .font: Font.custom("HelveticaNeue", size: 11)
 ])
 let titleLineTwo = PDFAttributedText(text: attributedTitleLineTwo)
 
 */
