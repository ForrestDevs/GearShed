//
//  PDFExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-30.
//
import Foundation
import SwiftUI
import WebKit

struct GearShedPDFView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var gsData: GearShedData
    @State private var gsPDFType: GearShedPDFType = .shed
    
    var body: some View {
        VStack {
            CaseIterablePicker(title: "", selection: $gsPDFType, display: \.rawValue.capitalized)
            switch gsPDFType {
            case .shed:
                WebView(htmlString: createHTML())
            case .brand:
                WebView(htmlString: createHTML())
            case .fav:
                WebView(htmlString: createHTML())
            case .wish:
                WebView(htmlString: createHTML())
            case .regret:
                WebView(htmlString: createHTML())
            }
        }
        .navigationBarTitle("Share Gear Shed", displayMode: .inline)
        .toolbar {
            cancelButton
            viewTitle
            exportButton
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
        let value = "$ \(gsData.totalCost(array: array))"
        return value
    }
    func weightCount(array: [Item]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            value = "\(gsData.totalGrams(array: array)) g"
        } else {
            let lbOz = gsData.totalLbsOz(array: array)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            value = "\(lb) lb \(oz) oz"
        }
        return value
    }
    func weightCount(pdfItems: [pdfItem]) -> String {
        var value: String = ""
        if Prefs.shared.weightUnit == "g" {
            let num = "\(totalGrams(array: pdfItems))"
            if !num.isEmpty {
                value = ", \(num) g"
            }
        } else {
            let lbOz = totalLbsOz(array: pdfItems)
            let lb = lbOz.lbs
            let oz = lbOz.oz
            if !lb.isEmpty || !oz.isEmpty {
                value = ", \(lb) lb \(oz) oz"
            }
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
        guard (item.weight == "0") || (item.lbs == "0" && item.oz == "0.00") else { return value }
        
        if Prefs.shared.weightUnit == "g" {
            value = "\(item.weight) g"
        } else {
            let lbs = item.lbs
            let oz = item.oz
            value = "\(lbs) Lbs \(oz) Oz"
        }
        return value
    }
//    func itemWeightUnitForGL(item: Item) -> String {
//            var value: String = ""
//            if Prefs.shared.weightUnit == "g" {
//                value = "\(item.weight) g"
//            } else {
//                let lbs = item.itemLbs
//                let oz = item.itemOZ
//                value = "\(lbs) Lbs \(oz) Oz"
//            }
//            return value
//        }
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
    func itemNameBrandText(item: pdfItem) -> String {
        let itemName = item.name
        let itemBrand = item.brand
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
    func itemWeightPriceText(item: pdfItem) -> String {
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
    //MARK: Create New HTML String and PDF
    func createHTML() -> String {
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
        
        func pdfType() -> String {
            var text: String = ""
            switch gsPDFType {
            case .shed:
                text = "Shelf View"
            case .brand:
                text = "Brand View"
            case .fav:
                text = "Favorite View"
            case .wish:
                text = "Wishlist View"
            case .regret:
                text = "Regret View"
            }
            return text
        }
        func pdfDate() -> String {
            var text: String = ""
            text = Date().monthDayYearDateText()
            return text
        }
        func pdfStats() -> String {
            switch gsPDFType {
            case .shed:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(shedCount())</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: gsData.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: gsData.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: gsData.items))</p>
                        </div>
                        <!--
                        """
            case .brand:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Shelves</p>
                            <p class="statVal">\(brandCount())</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: gsData.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: gsData.items))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: gsData.items))</p>
                        </div>
                        <!--
                        """
            case .fav:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: gsData.favItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: gsData.favItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: gsData.favItems))</p>
                        </div>
                        <!--
                        """
            case .wish:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: gsData.wishListItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: gsData.wishListItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Cost</p>
                            <p class="statVal">\(costCount(array: gsData.wishListItems))</p>
                        </div>
                        <!--
                        """
            case .regret:
                return """
                        -->
                        <div class="stat">
                            <p class="statTitle">Items</p>
                            <p class="statVal">\(itemCount(array: gsData.regretItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Weight</p>
                            <p class="statVal">\(weightCount(array: gsData.regretItems))</p>
                        </div>
                        <div class="stat">
                            <p class="statTitle">Invested</p>
                            <p class="statVal">\(costCount(array: gsData.regretItems))</p>
                        </div>
                        <!--
                        """
            }
        }
        func sectionItems(array: [pdfItem]) -> String {
            var text: String = ""
            for item in array {
                text.append(contentsOf:
                """
                <li class="item">\(itemNameBrandText(item: item))\(itemWeightPriceText(item: item))\(item.details)</li>
                """
                )
            }
            return text
        }
        func pdfItemSections() -> String {
            var finalText: String = "-->"
            var textFirst: String = ""
            switch gsPDFType {
            case .shed:
                for shelf in shelves {
                    let items = items.filter { $0.shed == shelf }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf)\(weightCount(pdfItems: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .brand:
                for brand in brands {
                    let items = items.filter { $0.brand == brand }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(brand)\(weightCount(pdfItems: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .fav:
                for shelf in shelves {
                    let items = favItems.filter { $0.shed == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf)\(weightCount(pdfItems: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .wish:
                for shelf in shelves {
                    let items = wishItems.filter { $0.shed == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf)\(weightCount(pdfItems: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
                            </ul>
                        </div>
                    </div>
                    """
                    )
                }
                finalText.append(contentsOf: textFirst)
            case .regret:
                for shelf in shelves {
                    let items = regretItems.filter { $0.shed == shelf }
                    guard items.count >= 1 else { continue }
                    textFirst.append(contentsOf:
                    """
                    <div class="itemListSection">
                        <div class="sectionHeader">
                            <p class="sectionHeaderTitle">\(shelf)\(weightCount(pdfItems: items))</p>
                        </div>
                        <div class="sectionItems">
                            <ul>
                                <!-- -->\(sectionItems(array: items))<!-- -->
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
        
        guard let htmlFile = Bundle.main.url(forResource: "gearShedTemplate", withExtension: "html")
            else { fatalError("Error locating HTML file.") }
        
        guard let htmlContent = try? String(contentsOf: htmlFile)
            else { fatalError("Error getting HTML file content.") }
        
        guard let imageURL = Bundle.main.url(forResource: "gearShedBlack", withExtension: "png")
            else { fatalError("Error locating image file.") }
        
        // Replacing header placeholders with values
        let htmlHeader = htmlContent
            .replacingOccurrences(of: "#USERNAME#", with: "\(Prefs.shared.pdfUserName)'s")
            .replacingOccurrences(of: "#PDF_TYPE#", with: pdfType())
            .replacingOccurrences(of: "#DATE#", with: pdfDate())
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
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Share Gear Shed")
        }
    }
    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button { presentationMode.wrappedValue.dismiss() } label: { Text("Cancel") }
        }
    }
    private var exportButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { printPDF() } label: { Text("Export") }
        }
    }
}

struct WebView: UIViewRepresentable {
    let htmlString: String
    let webView = WKWebView()
    func makeUIView(context: Context) -> some UIView {
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}
    
//class PDF {
//    /**
//        Generates a PDF using the given print formatter and saves it to the user's document directory.
//
//        - parameters:
//        - printFormatter: The print formatter used to generate the PDF.
//
//        - returns: The generated PDF.
//    */
//    class func generate(htmlString: String) -> Data {
//
//        // assign the print formatter to the print page renderer
//        let renderer = CustomPrintPageRenderer()
//        renderer.addPrintFormatter(UIMarkupTextPrintFormatter(markupText: htmlString), startingAtPageAt: 0)
//
////        // assign paperRect and printableRect values
////        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
////        renderer.setValue(page, forKey: "paperRect")
////        renderer.setValue(page, forKey: "printableRect")
//
//        // create pdf context and draw each page
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
//
//        for i in 0..<renderer.numberOfPages {
//            UIGraphicsBeginPDFPage()
//            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
//        }
//
//        UIGraphicsEndPDFContext();
//
////        // save data to a pdf file and return
////        guard nil != (try? pdfData.write(to: outputURL, options: .atomic))
////            else { fatalError("Error writing PDF data to file.") }
//
//        return pdfData as Data
//    }
//
//    class func generateURL(htmlString: String) -> URL {
//
//        // assign the print formatter to the print page renderer
//        let renderer = CustomPrintPageRenderer()
//        renderer.addPrintFormatter(UIMarkupTextPrintFormatter(markupText: htmlString), startingAtPageAt: 0)
//
//        // assign paperRect and printableRect values
////        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
////        renderer.setValue(page, forKey: "paperRect")
////        renderer.setValue(page, forKey: "printableRect")
//
//        // create pdf context and draw each page
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
//
//        for i in 0..<renderer.numberOfPages {
//            UIGraphicsBeginPDFPage()
//            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
//        }
//
//        UIGraphicsEndPDFContext();
//
//        // save data to a pdf file and return
//        guard nil != (try? pdfData.write(to: outputURL, options: .atomic))
//            else { fatalError("Error writing PDF data to file.") }
//
//        return outputURL as URL
//    }
//
//    private class var outputURL: URL {
//
//
//
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            else { fatalError("Error getting user's document directory.") }
//
//        let url = directory.appendingPathComponent(outputFileName).appendingPathExtension("pdf")
//        print("open \(url.path)")
//        return url
//    }
//
//    private class var outputFileName: String {
//        return "generated-\(Int(Date().timeIntervalSince1970))"
//    }
//}
//
//class CustomPrintPageRenderer: UIPrintPageRenderer {
//
//    let A4PageWidth: CGFloat = 595.2
//    let A4PageHeight: CGFloat = 841.8
//
//    override init() {
//        super.init()
//
//        // Specify the frame of the A4 page.
//        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
//
//        // Set the page frame.
//        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
//
//        // Set the horizontal and vertical insets (that's optional).
//        //self.setValue(NSValue(CGRect: pageFrame), forKey: "printableRect")
//        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 15.0)), forKey: "printableRect")
//
//
//        self.headerHeight = 50.0
//        self.footerHeight = 50.0
//    }
//}

//wkWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)

//private func markupTextPrintFormatter() -> UIPrintFormatter {
//    return UIMarkupTextPrintFormatter(markupText: HTML.get(from: "index.html"))
//}

//    .addAction(title: "UIMarkupTextPrintFormatter") { action in
//        let data = PDF.generate(using: self.markupTextPrintFormatter())
//        self.loadIntoWKWebView(data)
//    }

//private func loadIntoWKWebView(_ data: Data) {
//    wkWebView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: Bundle.main.bundleURL)
//}

//printController.printFormatter = self.markupTextPrintFormatter()
//presentPrintController()

//let printController = UIPrintInteractionController.shared
//
//func presentPrintController() {
//    printController.present(animated: true) { (controller, completed, error) in
//        print(error ?? "Print controller presented.")
//    }
//}

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
 
 
 
 switch gsPDFType {
             case .shed:
                 WebView(htmlString: createHTML())
             case .brand:
                 WebView(htmlString: createHTML())
             case .fav:
                 WebView(htmlString: createHTML())
             case .wish:
                 WebView(htmlString: createHTML())
             case .regret:
                 WebView(htmlString: createHTML())
             }
 
 */


//func statTitleWeightSetting() -> String {
//    var value: String = ""
//    if Prefs.shared.weightUnit == "g" {
//        value = "Weight (g)"
//    } else {
//        value = "Weight (Lbs/Oz)"
//    }
//    return value
//}
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
//func sectionHeaderTitle(name: String, array: [pdfItem]) -> PDFAttributedText {
//    let attributedTitle = NSMutableAttributedString(string: " \(name), \(weightCount(pdfItems: array))", attributes: [
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
//
//    switch gsPDFType {
//    case .shed:
//        text = "Shed"
//    case .brand:
//        text = "Brand"
//    case .fav:
//        text = "Fav"
//    case .wish:
//        text = "Wish"
//    case .regret:
//        text = "Regret"
//    }
//
//    let attributedTitle = NSMutableAttributedString(string: "\(text) View | \(Date().monthDayYearDateText())", attributes: [
//        .font: UIFont(name: "HelveticaNeue", size: 11)!
//    ])
//    let title = PDFAttributedText(text: attributedTitle)
//    return title
//}
//func stat00() -> String {
//    switch gsPDFType {
//    case .shed:
//        return "Shelves (#)"
//    case .brand:
//        return "Brands (#)"
//    case .fav:
//        return "Gear (#)"
//    case .wish:
//        return "Gear (#)"
//    case .regret:
//        return "Gear (#)"
//    }
//}
//func stat01() -> String {
//    switch gsPDFType {
//    case .shed:
//        return "Gear (#)"
//    case .brand:
//        return "Gear (#)"
//    case .fav:
//        return statTitleWeightSetting()
//    case .wish:
//        return statTitleWeightSetting()
//    case .regret:
//        return statTitleWeightSetting()
//    }
//}
//func stat02() -> String {
//    switch gsPDFType {
//    case .shed:
//        return statTitleWeightSetting()
//    case .brand:
//        return statTitleWeightSetting()
//    case .fav:
//        return "Invested ($)"
//    case .wish:
//        return "Cost ($)"
//    case .regret:
//        return "Invested ($)"
//    }
//}
//func stat03() -> String {
//    switch gsPDFType {
//    case .shed:
//        return "Invested ($)"
//    case .brand:
//        return "Invested ($)"
//    case .fav:
//        return ""
//    case .wish:
//        return ""
//    case .regret:
//        return ""
//    }
//}
//func stat10() -> String {
//    switch gsPDFType {
//    case .shed:
//        return shedCount()
//    case .brand:
//        return brandCount()
//    case .fav:
//        return itemCount(array: gsData.favItems)
//    case .wish:
//        return itemCount(array: gsData.wishListItems)
//    case .regret:
//        return itemCount(array: gsData.regretItems)
//    }
//}
//func stat11() -> String {
//    switch gsPDFType {
//    case .shed:
//        return itemCount(array: gsData.items)
//    case .brand:
//        return itemCount(array: gsData.items)
//    case .fav:
//        return weightCount(array: gsData.favItems)
//    case .wish:
//        return weightCount(array: gsData.wishListItems)
//    case .regret:
//        return weightCount(array: gsData.regretItems)
//    }
//}
//func stat12() -> String {
//    switch gsPDFType {
//    case .shed:
//        return weightCount(array: gsData.items)
//    case .brand:
//        return weightCount(array: gsData.items)
//    case .fav:
//        return costCount(array: gsData.favItems)
//    case .wish:
//        return costCount(array: gsData.wishListItems)
//    case .regret:
//        return costCount(array: gsData.regretItems)
//    }
//}
//func stat13() -> String {
//    switch gsPDFType {
//    case .shed:
//        return costCount(array: gsData.items)
//    case .brand:
//        return costCount(array: gsData.items)
//    case .fav:
//        return ""
//    case .wish:
//        return ""
//    case .regret:
//        return ""
//    }
//}
//func createGSPDF() -> Data {
//    //MARK: Converting data in PDF Data Models
//    var shelves = [String]()
//    var brands = [String]()
//    var items = [pdfItem]()
//    var favItems = [pdfItem]()
//    var wishItems = [pdfItem]()
//    var regretItems = [pdfItem]()
//    for item in gsData.items {
//        let newItem = pdfItem (
//            name: item.name,
//            brand: item.brandName,
//            shed: item.shedName,
//            weight: item.weight,
//            lbs: item.itemLbs,
//            oz: item.itemOZ,
//            price: item.price,
//            details: item.detail,
//            isFavourite: item.isFavourite,
//            isWish: item.isWishlist,
//            isRegret: item.isRegret)
//        items.append(newItem)
//    }
//    for item in gsData.favItems {
//        let newItem = pdfItem (
//            name: item.name,
//            brand: item.brandName,
//            shed: item.shedName,
//            weight: item.weight,
//            lbs: item.itemLbs,
//            oz: item.itemOZ,
//            price: item.price,
//            details: item.detail,
//            isFavourite: item.isFavourite,
//            isWish: item.isWishlist,
//            isRegret: item.isRegret)
//        favItems.append(newItem)
//    }
//    for item in gsData.wishListItems {
//        let newItem = pdfItem (
//            name: item.name,
//            brand: item.brandName,
//            shed: item.shedName,
//            weight: item.weight,
//            lbs: item.itemLbs,
//            oz: item.itemOZ,
//            price: item.price,
//            details: item.detail,
//            isFavourite: item.isFavourite,
//            isWish: item.isWishlist,
//            isRegret: item.isRegret)
//        wishItems.append(newItem)
//    }
//    for item in gsData.regretItems {
//        let newItem = pdfItem (
//            name: item.name,
//            brand: item.brandName,
//            shed: item.shedName,
//            weight: item.weight,
//            lbs: item.itemLbs,
//            oz: item.itemOZ,
//            price: item.price,
//            details: item.detail,
//            isFavourite: item.isFavourite,
//            isWish: item.isWishlist,
//            isRegret: item.isRegret)
//        regretItems.append(newItem)
//    }
//    for shed in gsData.sheds {
//        shelves.append(shed.name)
//    }
//    for brand in gsData.brands {
//        brands.append(brand.name)
//    }
//    // MARK: Initialize PDF and Size
//    let document = PDFDocument(format: .a4)
//    // MARK: Add Elements to PDF
//    let logo = PDFImage(image: Image(named: "gearShedBlack")!, size: CGSize(width: 100, height: 100))
//    document.add(.contentRight, image: logo)
//    document.add(space: 10)
//    //Title line one and two
//    document.add(.contentLeft, attributedTextObject: titleLineOne())
//    document.add(.contentLeft, attributedTextObject: titleLineTwo())
//    document.add(space: 15)
//    // Statbar
//    let statTable = PDFTable(rows: 2, columns: 4)
//    statTable.content = [
//        [stat00(), stat01(), stat02(), stat03()],
//        [stat10(), stat11(), stat12(), stat13()]
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
//    switch gsPDFType {
//    case .shed:
//        for shelf in shelves {
//            let items = items.filter { $0.shed == shelf }
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//
//
//            for item in items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
//                itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
//                itemGroup.add(attributedTextObject: statText(text: item.details))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//    case .brand:
//        brands.forEach { brand in
//            let brand = brand
//            let items = items.filter { $0.brand == brand }
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: brand, array: items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            document.add(group: sectionGroup)
//
//            document.add(space: 10)
//            items.forEach { item in
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.shed))
//                itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
//                itemGroup.add(attributedTextObject: statText(text: item.details))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//    case .fav:
//        for shelf in shelves {
//            let items = favItems.filter { $0.shed == shelf }
//            guard items.count >= 1 else { continue }
//
//
//
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//            for item in items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
//                itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
//                itemGroup.add(attributedTextObject: statText(text: item.details))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//
//    case .wish:
//        for shelf in shelves {
//            let items = wishItems.filter { $0.shed == shelf }
//            guard items.count >= 1 else { continue }
//
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//            for item in items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
//                itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
//                itemGroup.add(attributedTextObject: statText(text: item.details))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//
//    case .regret:
//        for shelf in shelves {
//            let items = regretItems.filter { $0.shed == shelf }
//            guard items.count >= 1 else { continue }
//
//
//
//            let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
//            let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
//            let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
//            sectionGroup.set(indentation: 0.0, left: true)
//            sectionGroup.addLineSeparator(style: lineStyle)
//            sectionGroup.add(space: 3)
//            sectionGroup.add(attributedTextObject: sectionHeaderTitle(name: shelf, array: items))
//            sectionGroup.add(space: 3)
//            sectionGroup.addLineSeparator(style: lineStyle)
//
//            document.add(group: sectionGroup)
//            document.add(space: 10)
//
//            for item in items {
//                let itemGroup = PDFGroup(allowsBreaks: false)
//                itemGroup.set(indentation: 15, left: true)
//                itemGroup.add(attributedTextObject: statText(text: item.name + " | " + item.brand))
//                itemGroup.add(attributedTextObject: statText(text: itemWeightUnit(item: item) + " | " + "$ " + item.price))
//                itemGroup.add(attributedTextObject: statText(text: item.details))
//                document.add(group: itemGroup)
//                document.add(space: 10)
//            }
//        }
//    }
//
//    // MARK: Generate and return PDF Data
//    let generator = PDFGenerator(document: document)
//    let pdf = try! generator.generateData()
//    return pdf
//}

//        .sheet(isPresented: $showShareSheet) {
//            ShareView(activityItems: [UIMarkupTextPrintFormatter(markupText: createHTML())])
//            if let data = createGSPDF() {
//               ShareView(activityItems: [data])
//           }
//           if let data = webViewDidFinishLoad(WKWebView().loadHTMLString(createHTML(), baseURL: Bundle.main.bundleURL)) {
//                ShareView(activityItems: [data])
//            }
//        }
//            switch gsPDFType {
//            case .shed:
//                PDFPreviews(data: createGSPDF())
//            case .brand:
//                PDFPreviews(data: createGSPDF())
//            case .fav:
//                PDFPreviews(data: createGSPDF())
//            case .wish:
//                PDFPreviews(data: createGSPDF())
//            case .regret:
//                PDFPreviews(data: createGSPDF())
//            }
//    @EnvironmentObject private var persistentStore: PersistentStore
//    @State private var showShareSheet : Bool = false
