//
//  PDFExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-30.
//

import SwiftUI
import UIKit
import PDFCreator

struct GearShedPDFView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var persistentStore: PersistentStore
    @EnvironmentObject private var gsData: GearShedData
    @State private var gsPDFType: GearShedPDFType = .shed
    @State private var showShareSheet : Bool = false
    
    var body: some View {
        VStack {
            CaseIterablePicker(title: "", selection: $gsPDFType, display: \.rawValue.capitalized)
            switch gsPDFType {
            case .shed:
                PDFPreviews(data: createGSPDF())
            case .brand:
                PDFPreviews(data: createGSPDF())
            case .fav:
                PDFPreviews(data: createGSPDF())
            case .wish:
                PDFPreviews(data: createGSPDF())
            case .regret:
                PDFPreviews(data: createGSPDF())
            }
        }
        .navigationBarTitle("Share Gear Shed", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { exportButton() }
            ToolbarItem(placement: .navigationBarLeading) { cancelButton() }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = createGSPDF() {
                ShareView(activityItems: [data])
            }
        }
    }
    
    //MARK: General Counting Functions
    func shedCount() -> String {
        let count = gsData.sheds.count
        return String(count)
    }
    func brandCount() -> String {
        let count = gsData.brands.count
        return String(count)
    }
    func itemCount(array: [Item]) -> String {
        let count = array.count
        return String(count)
    }
    func costCount(array: [Item]) -> String {
        let value = gsData.totalCost(array: array)
        return value
    }
    func weightCount(array: [Item]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = gsData.totalGrams(array: array)
        } else {
            let lbOz = gsData.totalLbsOz(array: array)
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
    func itemWeightUnitForGL(item: Item) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(item.weight) g"
        } else {
            let lbs = item.itemLbs
            let oz = item.itemOZ
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
    //MARK: Text Formatting/ Logic Functions
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
    func statText(text: String) -> PDFAttributedText {
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
            .font: UIFont(name: "HelveticaNeue", size: 11)!
        ])
        let title = PDFAttributedText(text: attributedTitleLineOne)
        return title
    }
    func titleLineTwo() -> PDFAttributedText {
        var text: String = ""
        
        switch gsPDFType {
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
    func stat00() -> String {
        switch gsPDFType {
        case .shed:
            return "Shelves (#)"
        case .brand:
            return "Brands (#)"
        case .fav:
            return "Gear (#)"
        case .wish:
            return "Gear (#)"
        case .regret:
            return "Gear (#)"
        }
    }
    func stat01() -> String {
        switch gsPDFType {
        case .shed:
            return "Gear (#)"
        case .brand:
            return "Gear (#)"
        case .fav:
            return statTitleWeightSetting()
        case .wish:
            return statTitleWeightSetting()
        case .regret:
            return statTitleWeightSetting()
        }
    }
    func stat02() -> String {
        switch gsPDFType {
        case .shed:
            return statTitleWeightSetting()
        case .brand:
            return statTitleWeightSetting()
        case .fav:
            return "Invested ($)"
        case .wish:
            return "Cost ($)"
        case .regret:
            return "Invested ($)"
        }
    }
    func stat03() -> String {
        switch gsPDFType {
        case .shed:
            return "Invested ($)"
        case .brand:
            return "Invested ($)"
        case .fav:
            return ""
        case .wish:
            return ""
        case .regret:
            return ""
        }
    }
    func stat10() -> String {
        switch gsPDFType {
        case .shed:
            return shedCount()
        case .brand:
            return brandCount()
        case .fav:
            return itemCount(array: gsData.favItems)
        case .wish:
            return itemCount(array: gsData.wishListItems)
        case .regret:
            return itemCount(array: gsData.regretItems)
        }
    }
    func stat11() -> String {
        switch gsPDFType {
        case .shed:
            return itemCount(array: gsData.items)
        case .brand:
            return itemCount(array: gsData.items)
        case .fav:
            return weightCount(array: gsData.favItems)
        case .wish:
            return weightCount(array: gsData.wishListItems)
        case .regret:
            return weightCount(array: gsData.regretItems)
        }
    }
    func stat12() -> String {
        switch gsPDFType {
        case .shed:
            return weightCount(array: gsData.items)
        case .brand:
            return weightCount(array: gsData.items)
        case .fav:
            return costCount(array: gsData.favItems)
        case .wish:
            return costCount(array: gsData.wishListItems)
        case .regret:
            return costCount(array: gsData.regretItems)
        }
    }
    func stat13() -> String {
        switch gsPDFType {
        case .shed:
            return costCount(array: gsData.items)
        case .brand:
            return costCount(array: gsData.items)
        case .fav:
            return ""
        case .wish:
            return ""
        case .regret:
            return ""
        }
    }
    
    func createGSPDF() -> Data {
        //MARK: Converting data in PDF Data Models
        var shelves = [String]()
        var brands = [String]()
        var items = [pdfItem]()
        var favItems = [pdfItem]()
        var wishItems = [pdfItem]()
        var regretItems = [pdfItem]()
        for item in gsData.items {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail,
                isFavourite: item.isFavourite,
                isWish: item.isWishlist,
                isRegret: item.isRegret)
            items.append(newItem)
        }
        for item in gsData.favItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail,
                isFavourite: item.isFavourite,
                isWish: item.isWishlist,
                isRegret: item.isRegret)
            favItems.append(newItem)
        }
        for item in gsData.wishListItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail,
                isFavourite: item.isFavourite,
                isWish: item.isWishlist,
                isRegret: item.isRegret)
            wishItems.append(newItem)
        }
        for item in gsData.regretItems {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                lbs: item.itemLbs,
                oz: item.itemOZ,
                price: item.price,
                details: item.detail,
                isFavourite: item.isFavourite,
                isWish: item.isWishlist,
                isRegret: item.isRegret)
            regretItems.append(newItem)
        }
        for shed in gsData.sheds {
            shelves.append(shed.name)
        }
        for brand in gsData.brands {
            brands.append(brand.name)
        }
        // MARK: Initialize PDF and Size
        let document = PDFDocument(format: .a4)
        // MARK: Add Elements to PDF
        let logo = PDFImage(image: Image(named: "Light-Transparent")!, size: CGSize(width: 120, height: 100))
        document.add(.contentCenter, image: logo)
        document.add(space: 10)
        //Title line one and two
        document.add(.contentLeft, attributedTextObject: titleLineOne())
        document.add(.contentLeft, attributedTextObject: titleLineTwo())
        document.add(space: 15)
        // Statbar
        let statTable = PDFTable(rows: 2, columns: 4)
        statTable.content = [
            [stat00(), stat01(), stat02(), stat03()],
            [stat10(), stat11(), stat12(), stat13()]
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
        //Items
        switch gsPDFType {
        case .shed:
            for shelf in shelves {
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
            
                let items = items.filter { $0.shed == shelf }
                
                for item in items {
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
            for shelf in shelves {
                let items = favItems.filter { $0.shed == shelf }
                guard items.count >= 1 else { continue }
                
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
                
                for item in items {
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
            for shelf in shelves {
                let items = wishItems.filter { $0.shed == shelf }
                guard items.count >= 1 else { continue }
                
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
                
                for item in items {
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
            for shelf in shelves {
                let items = regretItems.filter { $0.shed == shelf }
                guard items.count >= 1 else { continue }
                
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
                
                for item in items {
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
 //var gearCellArray = [PDFGroup]()
 
 //document.enable(columns: 2, widths: [0.5, 0.5], spacings: [0])
 
 document.enable(columns: 2, widths: [0.5, 0.5], spacings: [10])
 document.
 for i in 0..<9 { // This is an example for the content
     document.add(text: "\(i)-A-B-C-D-E-F-G-H-I-J-K-L-M-N-O-P-Q-R")
 }
 document.disableColumns(addPageBreak: false);
 
 /*for (idx, item) in items.enumerated() {
 
     
     
     document.add(group: itemGroup)
     //gearCellArray.append(itemGroup)
     
     //print("loop \(idx)")
                         
     /*if idx == items.endIndex-1 {
         
         print("Adding cell array")
         
         document.enable(columns: 2, widths: [0.5, 0.5], spacings: [0])
         
         for cell in gearCellArray {
             
             //document.add(space: 10)
         }
         
         
         
         //var firstItem = 0
         //var secondItem = 0
         
         /*for (idx, cell) in gearCellArray.enumerated() {
             let section = PDFSection(columnWidths: [0.5, 0.5])
             if idx.isEven {
                 section.columns[0].add(.left, group: cell)
                 document.add(section: section)
                 document.add(space: 10)
                 if idx == gearCellArray.endIndex-1 {
                     
                 }
             } else if idx.isOdd {
                 section.columns[1].add(.right, group: cell)
                 document.add(section: section)
                 document.add(space: 10)
             }
         }*/
     }*/
     
     //
 }*/
 
 //document.disableColumns(addPageBreak: false)

 //gearCellArray = [PDFGroup]()
 
 func pdfData() -> Data? {
     var tableData = [TableData]()
     
     for item in gsData.items {
         tableData.append(TableData(name: item.name, detail: item.detail, brand: item.brandName, shed: item.shedName, price: item.price, weight: item.weight))
     }
     
     let tableDataHeaderTitles =  ["name", "details", "brand", "shed", "price", "weight"]
     
     let pdfCreator = PDFCreator(tableDataItems: tableData, tableDataHeaderTitles: tableDataHeaderTitles)
     
     let data = pdfCreator.create()
     
     return data
 }
 */

