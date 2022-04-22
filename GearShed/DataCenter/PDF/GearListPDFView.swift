//
//  GearListPDFView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-17.
//

import SwiftUI
import PDFCreator

struct GearListPDFView: View {
    @EnvironmentObject private var detailManager: DetailViewManager
    @EnvironmentObject private var glData: GearlistData
    @State private var glPDFType: GearListPDFType = .list
    @State var selectedGearlist: Gearlist
//    @State private var showShareSheet : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                CaseIterablePicker(title: "", selection: $glPDFType, display: \.rawValue.capitalized)
                switch glPDFType {
                case .list:
                    WebView(htmlString: createHTML())
                case .pile:
                    WebView(htmlString: createHTML())
                case .pack:
                    WebView(htmlString: createHTML())
                case .diary:
                    WebView(htmlString: createHTML())
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                backButtonToolBarItem
                viewTitle
                exportButton
            }
//            .sheet(isPresented: $showShareSheet) {
//                if let data = createGLPDF() {
//                    ShareView(activityItems: [data])
//                }
//            }
        }
        .transition(.move(edge: .bottom))
    }
    
    //MARK: General Counting Functions
    func gearlistItems() -> [Item] {
        let importGL = glData.gearlists.filter { $0.id == selectedGearlist.id}.first!
        let items = importGL.items
        return items
    }
    func diaryCount() -> String {
        let importGL = glData.gearlists.filter { $0.id == selectedGearlist.id}.first!
        let count = importGL.diaries.count
        return String(count)
    }
    func weightCountForStat(type: Int) -> String {
        var value: String = ""
        if type == 0 {
            if Prefs.shared.weightUnit == "g" {
                value = glData.gearlistTotalGrams(gearlist: selectedGearlist)
            } else {
                let lbOz = glData.gearlistTotalLbsOz(gearlist: selectedGearlist)
                let lb = lbOz.lbs
                let oz = lbOz.oz
                value = "\(lb) Lbs + \(oz) Oz"
            }
        } else if type == 1 {
            if Prefs.shared.weightUnit == "g" {
                value = glData.gearlistPileTotalGrams(gearlist: selectedGearlist)
            } else {
                let lbOz = glData.gearlistPileTotalLbsOz(gearlist: selectedGearlist)
                let lb = lbOz.lbs
                let oz = lbOz.oz
                value = "\(lb) Lbs + \(oz) Oz"
            }
        } else if type == 2 {
            if Prefs.shared.weightUnit == "g" {
                value = glData.gearlistPackTotalGrams(gearlist: selectedGearlist)
            } else {
                let lbOz = glData.gearlistPackTotalLbsOz(gearlist: selectedGearlist)
                let lb = lbOz.lbs
                let oz = lbOz.oz
                value = "\(lb) Lbs + \(oz) Oz"
            }
        }
        return value
    }
    func costCountForPilePack(type: String) -> String {
        var value: String = ""
        if type == "pile" {
            var arrayString = [String]()
            for pile in selectedGearlist.piles {
                for item in pile.items {
                    arrayString.append(item.price)
                }
            }
            let intArray = arrayString.map { Int($0) ?? 0 }
            let total = intArray.reduce(0, +)
            let totalString = String(total)
            value = totalString
        } else if type == "pack" {
            var arrayString = [String]()
            for pack in selectedGearlist.packs {
                for item in pack.items {
                    arrayString.append(item.price)
                }
            }
            let intArray = arrayString.map { Int($0) ?? 0 }
            let total = intArray.reduce(0, +)
            let totalString = String(total)
            value = totalString
        }
        return value
    }
    func costCount(array: [Item]) -> String {
        let value = "$ \(glData.totalCost(array: array))"
        return value
    }
    func weightCount(array: [Item]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(glData.totalGrams(array: array)) g"
        } else {
            let lbOz = glData.totalLbsOz(array: array)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            value = "\(lb) Lbs + \(oz) Oz"
        }
        return value
    }

    func itemWeightUnit(item: Item) -> String {
        var value: String = ""
        guard (item.weight == "0") || (item.itemLbs == "0" && item.itemOZ == "0.00") else { return value }
        
        if Prefs.shared.weightUnit == "g" {
            value = "\(item.weight) g"
        } else {
            let lbs = item.itemLbs
            let oz = item.itemLbs
            value = "\(lbs) Lbs \(oz) Oz"
        }
        return value
    }

    
    //MARK: Text Formatting/ Logic Functions
    func itemNameBrandText(item: Item) -> String {
        let itemName = item.name
        let itemBrand = item.brandName
        if itemName.isEmpty && itemBrand.isEmpty {
            return ""
        } else if itemName.isEmpty && !itemBrand.isEmpty {
            return "\(itemBrand); "
        } else if itemBrand.isEmpty && !itemName.isEmpty {
            return "\(itemName); "
        } else if !itemBrand.isEmpty && !itemName.isEmpty {
            return "\(itemName) | \(itemBrand); "
        } else {
            return ""
        }
    }
    func itemWeightPriceText(item: Item) -> String {
        let itemWeightText = itemWeightUnit(item: item)
        let itemPriceText = item.price
        if itemWeightText.isEmpty && itemPriceText.isEmpty {
            return ""
        } else if itemPriceText.isEmpty && !itemWeightText.isEmpty {
            return "\(itemWeightText); "
        } else if itemWeightText.isEmpty && !itemPriceText.isEmpty {
            return "\(itemPriceText); "
        } else if !itemWeightText.isEmpty && !itemPriceText.isEmpty {
            return "\(itemWeightText) | \(itemPriceText); "
        } else {
            return ""
        }
    }
    
    func createHTML() -> String {
        //MARK: Converting data in PDF Data Models
        let importGL = glData.gearlists.filter { $0.id == selectedGearlist.id}.first!
        let shedItemArray = glData.sectionByShed(itemArray: importGL.items)
        
        func pdfType() -> String {
            var text: String = ""
            switch glPDFType {
            case .list:
                text = "List View"
            case .pile:
                text = "Pile View"
            case .pack:
                text = "Pack View"
            case .diary:
                text = "Diary View"
            }
            return text
        }
        func pdfDate() -> String {
            var text: String = ""
            text = Date().monthDayYearDateText()
            return text
        }
        func pdfStats() -> String {
            switch glPDFType {
            case .list:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(String(shedItemArray.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(String(importGL.items.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: importGL.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: importGL.items))</p>
                        </div>
                        <!--
                        """
            case .pile:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Piles</p>
                            <p class="statVal">\(String(importGL.pileCount))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(glData.gearlistPileTotalItems(gearlist: importGL))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCountForStat(type: 1))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCountForPilePack(type: "pile"))</p>
                        </div>
                        <!--
                        """
            case .pack:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(String(importGL.packs.count))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(glData.gearlistPackTotalItems(gearlist: importGL))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCountForStat(type: 2))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCountForPilePack(type: "pack"))</p>
                        </div>
                        <!--
                        """
            case .diary:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(diaryCount())</p>
                        </div>
                        <!--
                        """
            }
        }
        func sectionItems(array: [Item]) -> String {
            var text: String = ""
            for item in array {
                text.append(contentsOf:
                """
                <li class="item">\(itemNameBrandText(item: item))\(itemWeightPriceText(item: item))\(item.detail)</li>
                """
                )
            }
            return text
        }
        func pdfItemSections() -> String {
            var finalText: String = "-->"
            var textFirst: String = ""
            switch glPDFType {
            case .list:
                for shelf in shedItemArray {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf)\(weightCount(array: shelf.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: shelf.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .pile:
                for pile in importGL.piles {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(pile.name)\(weightCount(array: pile.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: pile.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .pack:
                for pack in importGL.packs {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(pack.name)\(weightCount(array: pack.items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: pack.items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .diary:
                for diary in importGL.diaries {
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(diary.name)</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(diary.details)<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            }
            finalText.append(contentsOf: "<!--")
            return finalText
        }
        
        guard let htmlFile = Bundle.main.url(forResource: "gearListTemplate", withExtension: "html")
            else { fatalError("Error locating HTML file.") }
        
        guard let htmlContent = try? String(contentsOf: htmlFile)
            else { fatalError("Error getting HTML file content.") }
        
        guard let imageURL = Bundle.main.url(forResource: "gearShedBlack", withExtension: "png")
            else { fatalError("Error locating image file.") }
        
        // Replacing header placeholders with values
        let htmlHeader = htmlContent
            .replacingOccurrences(of: "#USERNAME#", with: "\(Prefs.shared.pdfUserName)'s")
            .replacingOccurrences(of: "#GEARLIST_TITLE#", with: "\(importGL.name)")
            .replacingOccurrences(of: "#GEARLIST_START#", with: "\(importGL.startDate?.monthDayYearDateText() ?? "")")
            .replacingOccurrences(of: "#LOCATION#", with: "\(importGL.location ?? "")")
            .replacingOccurrences(of: "#COUNTRY#", with: "\(importGL.country ?? "")")
            .replacingOccurrences(of: "#PDF_TYPE#", with: pdfType())
            .replacingOccurrences(of: "#DATE#", with: pdfDate())
            .replacingOccurrences(of: "#TIME#", with: "CURRENT TIME")
            .replacingOccurrences(of: "{{IMG_SRC}}", with: imageURL.description)
        // Replacing stat bar placeholder with values
        let htmlStats = htmlHeader
            .replacingOccurrences(of: "#STAT_BAR#", with: pdfStats())
        // Replacing item section placeholder with value
        let finalHTML = htmlStats
            .replacingOccurrences(of: "#ITEM_SECTION#", with: pdfItemSections())
        
        return finalHTML
    }
    func printPDF() {
        let printController = UIPrintInteractionController.shared
        let printFormatter = UIMarkupTextPrintFormatter(markupText: createHTML())
        printController.printFormatter = printFormatter
        printController.present(animated: true) { (controller, completion, error) in
            print(error ?? "Print controller presented.")
        }
    }
    
    private var backButtonToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation {
                    detailManager.secondaryTarget = .noView
                }
            } label: {
                Text("Cancel")
            }
        }
    }
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Share Gear List")
        }
    }
    private var exportButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { printPDF() } label: { Text("Export") }
        }
    }
}

//    func itemWeightUnit(item: pdfItem) -> String {
//        var value: String = ""
//        if Prefs.shared.weightUnit == "g" {
//            value = "\(item.weight) g"
//        } else {
//            let lbs = item.lbs
//            let oz = item.oz
//            value = "\(lbs) Lbs \(oz) Oz"
//        }
//        return value
//    }
//    func totalGrams(array: [pdfItem]) -> String {
//        var arrayString = [String]()
//        for x in array {
//            arrayString.append(x.weight)
//        }
//        let intArray = arrayString.map { Int($0) ?? 0 }
//        let total = intArray.reduce(0, +)
//        let totalString = String(total)
//        return totalString
//    }
//    func itemWeightUnitForGL(item: Item) -> String {
//        var value: String = ""
//        if Prefs.shared.weightUnit == "g" {
//            value = "\(item.weight) g"
//        } else {
//            let lbs = item.itemLbs
//            let oz = item.itemOZ
//            value = "\(lbs) Lbs \(oz) Oz"
//        }
//        return value
//    }
//func statTitleTextBold(text: String ) -> PDFAttributedText {
//    let attributedTitle = NSMutableAttributedString(string: "\(text)", attributes: [
//        .font: UIFont(name: "HelveticaNeueBold", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitle)
//    return title
//}
//func statText(text: String) -> PDFAttributedText {
//    let attributedTitle = NSMutableAttributedString(string: "\(text)", attributes: [
//        .font: UIFont(name: "HelveticaNeue", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitle)
//    return title
//}
//func statTitleWeightSetting() -> String {
//    var value: String = ""
//    if Prefs.shared.weightUnit == "g" {
//        value = "Weight (g)"
//    } else {
//        value = "Weight (Lbs/Oz)"
//    }
//    return value
//}
//func sectionHeaderTitleForGL(name: String, array: [Item]) -> PDFAttributedText {
//    let attributedTitle = NSMutableAttributedString(string: " \(name), \(weightCount(array: array))", attributes: [
//        .font: UIFont(name: "HelveticaNeueBold", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitle)
//    return title
//}
//func titleLineOne() -> PDFAttributedText {
//    let attributedTitleLineOne = NSMutableAttributedString(string: "\(Prefs.shared.pdfUserName)'s GEAR SHED", attributes: [
//        .font: UIFont(name: "HelveticaNeue", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitleLineOne)
//    return title
//}
//func titleLineTwo() -> PDFAttributedText {
//    var text: String = ""
//    switch glPDFType {
//    case .list:
//        text = "List View"
//    case .pile:
//        text = "Pile View"
//    case .pack:
//        text = "Pack View"
//    case .diary:
//        text = "Diary View"
//    }
//    let attributedTitle = NSMutableAttributedString(string: "\(text) View | \(Date().monthDayYearDateText())", attributes: [
//        .font: UIFont(name: "HelveticaNeue", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitle)
//    return title
//}
//func stat00() -> String {
//    switch glPDFType {
//    case .list:
//        return "Gear (#)"
//    case .pile:
//        return "Gear (#)"
//    case .pack:
//        return "Gear (#)"
//    case .diary:
//        return "Entries (#)"
//    }
//}
//func stat01() -> String {
//    switch glPDFType {
//    case .list:
//        return statTitleWeightSetting()
//    case .pile:
//        return statTitleWeightSetting()
//    case .pack:
//        return statTitleWeightSetting()
//    case .diary:
//        return ""
//    }
//}
//func stat10() -> String {
//    switch glPDFType {
//    case .list:
//        return String(selectedGearlist.items.count)
//    case .pile:
//        return String(glData.gearlistPileTotalItems(gearlist: selectedGearlist))
//    case .pack:
//        return String(glData.gearlistPackTotalItems(gearlist: selectedGearlist))
//    case .diary:
//        return diaryCount()
//    }
//}
//func stat11() -> String {
//    switch glPDFType {
//    case .list:
//        return weightCountForStat(type: 0)
//    case .pile:
//        return weightCountForStat(type: 1)
//    case .pack:
//        return weightCountForStat(type: 2)
//    case .diary:
//        return ""
//    }
//}
//func createGLPDF() -> Data {
//    //MARK: Converting data in PDF Data Models
//    let importGL = glData.gearlists.filter { $0.id == selectedGearlist.id}.first!
//    let shedItemArray = glData.sectionByShed(itemArray: importGL.items)
//
//    // MARK: Initialize PDF and Size
//    let document = PDFDocument(format: .a4)
//    // MARK: Add Elements to PDF
//    let logo = PDFImage(image: Image(named: "Light-Transparent")!, size: CGSize(width: 120, height: 100))
//    document.add(.contentCenter, image: logo)
//    document.add(space: 10)
//    //Title line one and two
//    document.add(.contentLeft, attributedTextObject: titleLineOne())
//    document.add(.contentLeft, attributedTextObject: titleLineTwo())
//    document.add(space: 15)
//    // Statbar
//    let statTable = PDFTable(rows: 2, columns: 4)
//    statTable.content = [
//        [stat00(), stat01(), "", ""],
//        [stat10(), stat11(), "", ""]
//    ]
//    statTable.rows.allCellsStyle = PDFTableCellStyle.none
//    let firstRow = statTable[rows: 0..<1]
//    let firstRowStyle = PDFTableCellStyle(font: Font(name: "HelveticaNeue", size: 11)!)
//    firstRow.allCellsStyle = firstRowStyle
//    let secondRow = statTable[rows: 1..<2]
//    let secondRowStyle = PDFTableCellStyle(font: Font(name: "HelveticaNeue", size: 11)!)
//    secondRow.allCellsStyle = secondRowStyle
//    statTable.rows.allCellsAlignment = .left
//    // Set table padding and margin
//    statTable.padding = 2
//    statTable.margin = 0
//    document.add(table: statTable)
//    document.add(space: 15)
//    //Items
//    switch glPDFType {
//    case .list:
//        for shelf in shedItemArray {
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitleForGL(name: shelf.title, array: shelf.items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//            for item in shelf.items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: "\(item.name) | \(item.brandName)"))
//                itemGroup.add(attributedTextObject: statText(text: "\(itemWeightUnitForGL(item: item)) | $ \(item.price)"))
//                itemGroup.add(attributedTextObject: statText(text: item.detail))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//    case .pile:
//        for pile in importGL.piles {
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitleForGL(name: pile.name, array: pile.items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            document.add(group: sectionGroup)
//
//            document.add(space: 10)
//
//            for item in pile.items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: "\(item.name) | \(item.brandName)"))
//                itemGroup.add(attributedTextObject: statText(text: "\(itemWeightUnitForGL(item: item)) | $ \(item.price)"))
//                itemGroup.add(attributedTextObject: statText(text: item.detail))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//    case .pack:
//        for pack in importGL.packs {
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitleForGL(name: pack.name, array: pack.items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//            for item in pack.items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: "\(item.name) | \(item.brandName)"))
//                itemGroup.add(attributedTextObject: statText(text: "\(itemWeightUnitForGL(item: item)) | $ \(item.price)"))
//                itemGroup.add(attributedTextObject: statText(text: item.detail))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//
//    case .diary:
//        for i in 1..<20 {
//            document.add(text: String(i))
//        }
//        //EmptyView()
//    }
//
//    // MARK: Generate and return PDF Data
//    let generator = PDFGenerator(document: document)
//    let pdf = try! generator.generateData()
//    return pdf
//}
