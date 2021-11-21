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

    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @State private var showShareSheet : Bool = false
    
    var body: some View {
        VStack {
            PDFPreviews(data: createPDF())
        }
        .navigationBarTitle("Your PDF", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShareSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) { cancelButton() }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = createPDF() {
                ShareView(activityItems: [data])
            }
        }
    }
    
    func createPDF() -> Data {
        let document = PDFDocument(format: .a4)
        document.add(.contentCenter, text: "Create PDF documents easily.")
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
}






