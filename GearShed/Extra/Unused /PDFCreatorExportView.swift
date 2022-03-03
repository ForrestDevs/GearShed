//
//  PDFCreatorExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-19.
//
/*
import SwiftUI
import PDFCreator

struct PDFCreatorExportView: View {
    
    let username: String = "Greg Gannon's"

    
    struct mockItem {
        var name: String
        var brand: String
        var shed: String
        var weight: String
        var price: String
        var details: String
    }
    
    
    let mockItems: [mockItem] = [
        mockItem (
            name: "Alchemist 40/55",
            brand: "First Accent",
            shed: "Bags: Backpacks",
            weight: "1200",
            price: "200",
            details: "Dark smoke, 630 Denier nylon TPU"
        ),
        mockItem (
            name: "Altra 85",
            brand: "Arcteryx",
            shed: "Bags: Backpacks",
            weight: "1500",
            price: "400",
            details: "Black"
        ),
        mockItem (
            name: "Carry All 50L",
            brand: "MEC",
            shed: "Bags: Duffles",
            weight: "600",
            price: "150",
            details: "Black"
        ),
    ]
    let mockShelves: [String] = ["Bags: Backpacks", "Bags: Duffles"]
    var body: some View {
        VStack {
            PDFPreviews(data: createPDF())
        }
    }
    
    func createPDF() -> Data {
        // MARK: Create PDF and Size
        let document = PDFDocument(format: .a4)
        
        // MARK: Add Elements to PDF
        //document.add(text: username)
        let section = PDFSection(columnWidths: [0.75, 0.25])
        
        let leftSection = section.columns[0]
        leftSection.add(text: username + " GEAR SHED")
        leftSection.add(text: "Shed View | Nov 28, 2021")
        leftSection.add(space: 10)
        
        let statTable = PDFTable(rows: 2, columns: 4)
        statTable.content = [
            ["Shed (#)", "Gear (#)", "Weight (g)", "Invested ($)"],
            ["58", "71", "23,619", "2,164" ]
        ]
        statTable.rows.allCellsAlignment = .left
        statTable.rows.allCellsStyle = PDFTableCellStyle.none

        // Set table padding and margin
        statTable.padding = 2
        statTable.margin = 0
        
        leftSection.add(table: statTable)
        
        let rightSection = section.columns[1]
        let logo = PDFImage(image: Image(named: "PDFLogo")!, size: CGSize(width: 175, height: 175))
        
        rightSection.add(image: logo)
        
        document.add(section: section)
        
        mockShelves.forEach { shelf in
            let shelf = shelf
            let items = mockItems.filter { $0.shed == shelf }
            document.add(text: shelf)
            let lineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
            document.addLineSeparator(style: lineStyle)
            items.forEach { item in
                document.add(text: item.name + " | " + item.brand)
                document.add(text: item.weight + " g" + " | " + "$ " + item.price)
                document.add(text: item.details)
            }
        }
        
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
*/
