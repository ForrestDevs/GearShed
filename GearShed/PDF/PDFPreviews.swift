//
//  PDFPreviews.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-31.
//

import SwiftUI
import PDFKit

struct PDFPreviews: UIViewRepresentable {

    private var data: Data?
    
    private let autoScales : Bool
    
    init(data : Data?, autoScales : Bool = true ) {
        self.data = data
        self.autoScales = autoScales
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales =  self.autoScales
        
        if let data = self.data {
            pdfView.document = PDFDocument(data: data)
        }
        
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Empty
    }
}
