//
//  PDFCreatorExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-19.
//

import SwiftUI
import PDFCreator

struct PDFCreatorExportView: View {
    
    //@EnvironmentObject private var vm: GearShedData
    
    var body: some View {
        VStack {
            PDFPreviews(data: createPDF())
        }
    }
    
    func createPDF() -> Data {
        // MARK: Create PDF and Size
        let document = PDFDocument(format: .a4)
        
        // MARK: Add Elements to PDF
        /*let title = NSMutableAttributedString (
            string: "This is awesome",
            attributes: [
                .font: Font.systemFont(ofSize: 20.0),
                .foregroundColor: Color(red: 219.0 / 255.0, green: 100.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
            ]
        )*/
        
        let header = NSMutableAttributedString (
            string: "Created By GearShed",
            attributes: [
                .font: Font.systemFont(ofSize: 20.0),
                .foregroundColor: Color(red: 219.0 / 255.0, green: 100.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
            ]
        )
        
        //let image = Image(contentsOfFile: "AppIcon")!
        //let imageElement = PDFImage(image: image)
        //document.add(image: imageElement)
        
        //let bodyText = PDFAttributedText(text: title)
        let headerText = PDFAttributedText(text: header)
        
        //for _ in 1...200 {
        //    document.add(.contentCenter ,attributedTextObject: bodyText)
        //}
        document.add(.headerLeft, attributedTextObject: headerText)
        //document.add(.headerLeft, image: imageElement)
        
        
        /*
        
        /*for item in vm.items {
            tableData.append(TableData(name: item.name, detail: item.detail, brand: item.brandName, shed: item.shedName, price: item.price, weight: item.weight))
        }*/
        
        
        
        let table = PDFTable(rows: tableData.count, columns: 6)
        
        for x in 0...tableData.count {
            let cell = table[x,0]
            for item in tableData {
                cell.content = try! PDFTableContent(content: item.name)
            }
        }
        table.content = PDFTableCell(content: T##PDFTableContent?, alignment: T##PDFTableCellAlignment, style: T##PDFTableCellStyle?)
        
         
        
         
        document.add(.contentCenter, table: table)*/
        
        //let table = PDFTable(rows: 3, columns: 4)
        
        //let tableStyle = PDFTableStyle()
        //tableStyle.rowHeaderCount = 3
        //tableStyle.columnHeaderCount = 5
        
        //let colors = (fill: UIColor.blue, text: UIColor.orange)
        //let lineStyle = PDFLineStyle(type: .dashed, color: UIColor.gray, width: 10)
        //let borders = PDFTableCellBorders(left: lineStyle, top: lineStyle, right: lineStyle, bottom: lineStyle)
        //let font = UIFont.systemFont(ofSize: 20)
        //let cellStyle = PDFTableCellStyle(colors: colors, borders: borders, font: font)
        
        //rows = table[0..<3, 0..<3]
        
        //var rows = table[0...2, 1]
        
        
        //var columns = table[columns: 0...3]
        
        
        
        var tableData = [TableData]()
        
        for x in 1...5 {
            tableData.append(TableData(name: "item \(x)", detail: "detail \(x)", brand: "brand \(x)", shed: "shed \(x)", price: "\(x)", weight: "\(x)"))
        }
    
        
        func rowCount() -> Int {
            let count = tableData.count
            return count
        }
    
        // Create a table
        let table = PDFTable(rows: 5, columns: 7)

        // Tables can contain Strings, Numbers, Images or nil, in case you need an empty cell.
        // If you add a unknown content type, an assertion will be thrown and the rendering will stop.
        for x in 0...5 {
            let row = table[row: x]
            row.content = [nil, "item", "detail", "brand", "shed", "45", "56"]
        }
        
        /*for itemIn in tableData {
            for x in 0...rowCount() {
                let row = table[row: x]
                row.content = [nil, itemIn.name, itemIn.detail, itemIn.brand, itemIn.shed, itemIn.price, itemIn.weight]
            }
        }*/
        
        
        table.rows.allRowsAlignment = [.center, .left, .center, .right]

        // The widths of each column is proportional to the total width, set by a value between 0.0 and 1.0, representing percentage.

        table.widths = [
            0.1, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15
        ]

        // To speed up table styling, use a default and change it

        let style = PDFTableStyleDefaults.simple

        // Change standardized styles
        style.footerStyle = PDFTableCellStyle(
            colors: (
                fill: Color(red: 0.171875,
                              green: 0.2421875,
                              blue: 0.3125,
                              alpha: 1.0),
                text: Color.white
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),

            font: Font.systemFont(ofSize: 10)
        )

        // Simply set the amount of footer and header rows

        style.columnHeaderCount = 1
        style.footerCount = 1

        table.style = style

        // Style each cell individually
        table[1,1].style = PDFTableCellStyle(colors: (fill: Color.yellow, text: Color.black))

        // Set table padding and margin
        table.padding = 5.0
        table.margin = 10.0

        // In case of a linebreak during rendering we want to have table headers on each page.

        table.showHeadersOnEveryPage = true

        document.add(table: table)

        // Another table:
        /*
        table = PDFTable(rows: 50, columns: 4)
        table.widths = [0.1, 0.3, 0.3, 0.3]
        table.margin = 10
        table.padding = 10
        table.showHeadersOnEveryPage = false
        table.style.columnHeaderCount = 3

        for row in 0..<table.size.rows {
            table[row, 0].content = "\(row)".asTableContent
            for column in 1..<table.size.columns {
                table[row, column].content = "\(row),\(column)".asTableContent
            }
        }

        for i in stride(from: 3, to: 48, by: 3) {
            table[rows: i...(i + 2), column: 1].merge(with: PDFTableCell(content: Array(repeating: "\(i),1", count: 3).joined(separator: "\n").asTableContent,
                                                           alignment: .center))
        }
        for i in stride(from: 4, to: 47, by: 3) {
            table[rows: i...(i + 2), column: 2].merge(with: PDFTableCell(content: Array(repeating: "\(i),2", count: 3).joined(separator: "\n").asTableContent,
                                                           alignment: .center))
        }
        for i in stride(from: 5, to: 48, by: 3) {
            table[rows: i...(i + 2), column: 3].merge(with: PDFTableCell(content: Array(repeating: "\(i),3", count: 3).joined(separator: "\n").asTableContent,
                                                           alignment: .center))
        }

        table[rows: 0..<2, column: 2].merge()
        table[rows: 1..<3, column: 3].merge()

        document.add(table: table)*/
        //document.add(.headerCenter, text: "Created By GearShed")
        //document.add(.contentCenter, table: table)
        //document.add(.contentLeft, text: "Create PDF documents easily.")
        //document.add(.contentCenter, table: table)
        
        
        
        // MARK: Generate and return PDF Data
        let generator = PDFGenerator(document: document)
        let pdf = try! generator.generateData()
        return pdf
    }
}

struct PDFCreatorExportView_Previews: PreviewProvider {
    static var previews: some View {
        PDFCreatorExportView()
    }
}
