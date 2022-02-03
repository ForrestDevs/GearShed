//
//  PDFExportView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-30.
//

import SwiftUI
import PDFCreator

struct PDFExportView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var pdfType: Int = 0

    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @State private var showShareSheet : Bool = false
    
    var body: some View {
        VStack {
            
            Picker("PDF Type", selection: $pdfType) {
                Text("Shed").tag(0)
                Text("Brand").tag(1)
                Text("Fav").tag(2)
                Text("Wish").tag(3)
                Text("Regret").tag(4)
            }
            .pickerStyle(.segmented)
            
            PDFPreviews(data: createPDF())
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
    
    struct pdfItem {
        var name: String
        var brand: String
        var shed: String
        var weight: String
        var price: String
        var details: String
    }
    
    func shedCount() -> String {
        let count = viewModel.sheds.count
        return String(count)
    }
    
    func gearCount() -> String {
        let count = viewModel.items.count
        return String(count)
    }
    
    func weightCount() -> String {
        let value = viewModel.totalGrams(array: viewModel.items)
        return value
    }
    
    func costCount() -> String {
        let value = viewModel.totalCost(array: viewModel.items)
        return value
    }
    
    func createPDF() -> Data {
        
        var shelves = [String]()
        var items = [pdfItem]()
        
        for item in viewModel.items {
            let newItem = pdfItem (
                name: item.name,
                brand: item.brandName,
                shed: item.shedName,
                weight: item.weight,
                price: item.price,
                details: item.detail)
            items.append(newItem)
        }
        
        for shed in viewModel.sheds {
            shelves.append(shed.name)
        }
        
        // MARK: Create PDF and Size
        let document = PDFDocument(format: .a4)
        
        // MARK: Add Elements to PDF
        //document.add(text: username)
        let section = PDFSection(columnWidths: [0.25, 0.75])
        
        let leftSection = section.columns[0]
        let logo = PDFImage(image: Image(named: "PDFLogo")!, size: CGSize(width: 175, height: 175))
        leftSection.add(image: logo)
        
        
        let rightSection = section.columns[1]
        rightSection.add(text: "\(Prefs.shared.pdfUserName)'s GEAR SHED")
        
        let viewType: String = { () -> String in
            switch pdfType {
            case 0:
                return "Shed"
            case 1:
                return "Brand"
            case 2:
                return "Fav"
            case 3:
                return "Wish"
            case 4:
                return "Regret"
            default:
                return "Shed"
            }
        }()
        
        rightSection.add(text: "\(viewType) View | Nov 28, 2021")
        rightSection.add(space: 10)
        
        document.add(section: section)
        document.add(space: 10)
        
        let statTable = PDFTable(rows: 2, columns: 4)
        statTable.content = [
            ["Shed (#)", "Gear (#)", "Weight (g)", "Invested ($)"],
            [shedCount(), gearCount(), weightCount(), costCount()]
        ]
        statTable.rows.allCellsAlignment = .left
        statTable.rows.allCellsStyle = PDFTableCellStyle.none

        // Set table padding and margin
        statTable.padding = 2
        statTable.margin = 0
        
        document.add(table: statTable)
        
        shelves.forEach { shelf in
            let shelf = shelf
            let items = items.filter { $0.shed == shelf }
            document.add(text: shelf)
            let lineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
            document.addLineSeparator(style: lineStyle)
            items.forEach { item in
                document.add(text: item.name + " | " + item.brand)
                document.add(text: item.weight + " g" + " | " + "$ " + item.price)
                document.add(text: item.details)
                document.add(space: 5)
            }
        }
        
        // MARK: Generate and return PDF Data
        let generator = PDFGenerator(document: document)
        let pdf = try! generator.generateData()
        return pdf
    }
    
    /*func createPDF() -> Data {
        let document = PDFDocument(format: .a4)
        document.add(.contentCenter, text: "Create PDF documents easily.")
        let generator = PDFGenerator(document: document)
        let pdf = try! generator.generateData()
        return pdf
    }*/
    
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






