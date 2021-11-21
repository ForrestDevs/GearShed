//
//  PDFCreator.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-31.
//

import PDFKit

class PDFCreator: NSObject {
   
    let defaultOffset: CGFloat = 20
    
    let tableDataHeaderTitles: [String]
    let tableDataItems: [TableData]

    init(tableDataItems: [TableData], tableDataHeaderTitles: [String]) {
        self.tableDataItems = tableDataItems
        self.tableDataHeaderTitles = tableDataHeaderTitles
    }

    /**
     W: 8.5 inches * 72 DPI = 612 points
     H: 11 inches * 72 DPI = 792 points
     A4 = [W x H] 595 x 842 points
     */
    
    func create() -> Data {
        // default page format
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())

        let numberOfElementsPerPage = calculateNumberOfElementsPerPage(with: pageRect)
        
        let tableDataChunked: [[TableData]] = tableDataItems.chunkedElements(into: numberOfElementsPerPage)

        let data = renderer.pdfData { context in
            for tableDataChunk in tableDataChunked {
                
                context.beginPage()
                
                let cgContext = context.cgContext
                
                drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect)
                
                drawTableHeaderTitles(titles: tableDataHeaderTitles, drawContext: cgContext, pageRect: pageRect)
                
                drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk)
            }
        }
        return data
    }
    
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect) {
        
        drawContext.saveGState()
        drawContext.setLineWidth(3.0)

        // Draw header's 1 top horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset))
        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset * 3))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset * 3))
        drawContext.strokePath()

        // MARK: Draw header's 6 vertical lines
        drawContext.setLineWidth(2.0)
        drawContext.saveGState()
        // Tab width = ((page width) - (margin)) / (# of tabs)
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(6)
        
        for verticalLineIndex in 0...6 {
            // used to calculate starting x point of path
            let tabX = CGFloat(verticalLineIndex) * tabWidth
            // start drawing here (tabX + margin)
            drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset))
            // draw vertical line starting at tabX moving down to tabY (20 * 3)
            drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset * 3))
            // Paint line on screen following the path set
            drawContext.strokePath()
        }

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext: CGContext, pageRect: CGRect) {
        
        // prepare title attributes
        let textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]

        // draw titles
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(6)
        for titleIndex in 0..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + defaultOffset,
                                  y: defaultOffset * 3 / 2,
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [TableData]) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        let defaultStartY = defaultOffset * 3

        for elementIndex in 0..<tableDataItems.count {
            let yPosition = CGFloat(elementIndex) * defaultStartY + defaultStartY

            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
            let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(6)
            for titleIndex in 0...5 {
                var attributedText = NSAttributedString(string: "", attributes: textAttributes)
                switch titleIndex {
                case 0: attributedText = NSAttributedString(string: tableDataItems[elementIndex].name, attributes: textAttributes)
                case 1: attributedText = NSAttributedString(string: tableDataItems[elementIndex].detail, attributes: textAttributes)
                case 2: attributedText = NSAttributedString(string: tableDataItems[elementIndex].brand, attributes: textAttributes)
                case 3: attributedText = NSAttributedString(string: tableDataItems[elementIndex].shed, attributes: textAttributes)
                case 4: attributedText = NSAttributedString(string: tableDataItems[elementIndex].price, attributes: textAttributes)
                case 5: attributedText = NSAttributedString(string: tableDataItems[elementIndex].weight, attributes: textAttributes)
                default:
                    break
                }
                let tabX = CGFloat(titleIndex) * tabWidth
                let textRect = CGRect(x: tabX + defaultOffset,
                                      y: yPosition + defaultOffset,
                                      width: tabWidth,
                                      height: defaultOffset * 3)
                attributedText.draw(in: textRect)
            }

            // Draw content's 6 vertical lines
            for verticalLineIndex in 0...6 {
                let tabX = CGFloat(verticalLineIndex) * tabWidth
                drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: yPosition))
                drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: yPosition + defaultStartY))
                drawContext.strokePath()
            }

            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition + defaultStartY))
            drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: yPosition + defaultStartY))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
        let rowHeight = (defaultOffset * 3)
        let number = Int((pageRect.height - rowHeight) / rowHeight)
        return number
    }
}







