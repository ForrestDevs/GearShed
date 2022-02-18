//
//  PDFManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-17.
//

import Foundation
import PDFCreator
import UIKit
import SwiftUI

enum GearShedPDFType: String, CaseIterable {
    case shed, brand, fav, wish, regret
}

enum GearListPDFType: String, CaseIterable {
    case list, pile, pack, diary
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
    var isFavourite: Bool
    var isWish: Bool
    var isRegret: Bool
}



/*
 
 var shelves = [String]()
 var piles = [String]()
 var packs = [String]()
 var items = [pdfItem]()
 
 for shelf in shedItemArray {
     shelves.append(shelf.title)
     for item in shelf.items {
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
 }
 for pile in importGL.clusters {
     piles.append(pile.name)
 }
 for pack in importGL.containers {
     packs.append(pack.name)
 }
 
 guard items.count >= 1 else { continue }

 
 func sectionHeaderTitleForDiary(name: String, date: Date) -> PDFAttributedText {
     let attributedTitle = NSMutableAttributedString(string: " \(name), \(Date)", attributes: [
         .font: UIFont(name: "HelveticaNeueBold", size: 11)!
     ])
     let title = PDFAttributedText(text: attributedTitle)
     return title
 }
 
 for diary in importGL.diaries {
     let outlineStyle = PDFLineStyle(type: .full, color: Color.black, width: 1)
     let lineStyle = PDFLineStyle(type: .full, color: Color.clear, width: 0.1)
     let sectionGroup = PDFGroup(allowsBreaks: false, backgroundColor: Color.clear, outline: outlineStyle)
     
     let diaryDate = diary.gearlist.startDate?
     
     sectionGroup.set(indentation: 0.0, left: true)
     sectionGroup.addLineSeparator(style: lineStyle)
     sectionGroup.add(space: 3)
     sectionGroup.add(attributedTextObject: sectionHeaderTitleForDiary(name: diary.item?.name ?? "", date: diary.gearlist.startDate ?? ))
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
 
 
 
 class PDFManager: ObservableObject {
     
    
     @State var selectedGearlist: Gearlist?
     
     let gsData: GearShedData
     let glData: GearlistData
     
     init(gsData: GearShedData, glData: GearlistData, gearlist: Gearlist?) {
         self.gsData = gsData
         self.glData = glData
         
         if let selectedGearlist = selectedGearlist {
             self.selectedGearlist = selectedGearlist
         }

     }
     
     
     
     
     
     
     //MARK: PDF Generator
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
     
     
 }
 
 */
