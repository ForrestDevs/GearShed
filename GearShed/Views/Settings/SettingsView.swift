//
//  SettingsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation
import CoreData
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    
    @StateObject private var gsData: GearShedData
    @StateObject private var glData: GearlistData
    @StateObject private var backupManager: BackupManager
    
    @State private var confirmDataHasBeenAdded = false
    @State private var shedsAdded: Int = 0
    @State private var brandsAdded: Int = 0
    @State private var itemsAdded: Int = 0
    
    @State private var showExportSheet: Bool = false
    @State private var showImportSheet: Bool = false
    
    
    init(persistentStore: PersistentStore) {
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let backupManager = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: backupManager)
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 5)  {
                Text("Weight")
                
                Text("Price")
                
                Text("Data")
                
                Button {
                    self.showImportSheet.toggle()
                } label: {
                    Text("Load from back-up")
                }
                .alert(isPresented: $confirmDataHasBeenAdded) {
                    Alert(title: Text("Data Added"),
                          message: Text("Successfully loaded (\(itemsAdded) peices of Gear, \(shedsAdded) Sheds, and \(brandsAdded) Brands) from back up."),
                          dismissButton: .default(Text("OK")))
                }
                
                Button {
                    self.showExportSheet.toggle()
                } label: {
                    Text("Offline back-up")
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                viewTitle
            }
            .fileImporter(isPresented: $showImportSheet, allowedContentTypes: [UTType.json], allowsMultipleSelection: false) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.startAccessingSecurityScopedResource() {
                        backupManager.insertISBFromBackUp(url: selectedFile)
                        //backupManager.insertFromBackup(url: selectedFile)
                        do { selectedFile.stopAccessingSecurityScopedResource() }
                    } else {
                        // Handle denied access
                    }
                } catch {
                    // Handle failure.
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
            /*.fileImporter(isPresented: $showImportSheet, allowedContentTypes: [UTType.data, UTType.json], allowsMultipleSelection: false) { result in
                switch result {
                case .success(let urls):
                    loadURL(urls: urls)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }*/
            /*.fileExporter(isPresented: $showExportSheet, documents: backUpData(), contentType: .text) { result in
                switch result {
                    case .success(let url):
                        print("Saved to \(url)")
                    case .failure(let error):
                        
                    }
            }*/
            .sheet(isPresented: $showExportSheet) {
                if let data = backUpData() {
                    DocumentPicker(URLs: data)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func loadURL(urls: [URL]) {
        guard let url = urls.first else { return }
        backupManager.insertISBFromBackUp(url: url)
        //backupManager.insertFromBackup(url: url)
    }
    
    private func loadData() {
        //let currentShedCount = Shed.count() // what it is now
        //let currentBrandCount = Brand.count() // what it is now
        //let currentItemCount = Item.count() // what it is now
        //populateDatabaseFromJSON()
        //self.shedsAdded = Shed.count() - currentShedCount // now the differential
        //self.brandsAdded = Brand.count() - currentBrandCount // now the differential
        //self.itemsAdded = Item.count() - currentItemCount // now the differential
        //self.confirmDataHasBeenAdded = true
    }
    
    private func backUpData() -> [URL] {
        var urls = [URL]()
        urls.append(backupManager.writeAsJSON(items: gsData.items, itemImages: gsData.itemImages, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.activities, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes))
        return urls
    }
    
    /*private func backUpData() -> [URL] {
        var array = [URL]()
        array.append(backupManager.writeAsJSON(items: gsData.items, type: .item))
        array.append(backupManager.writeAsJSON(items: gsData.sheds, type: .shed))
        array.append(backupManager.writeAsJSON(items: gsData.brands, type: .brand))
        return array
    }*/
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Settings")
                .formatGreen()
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var URLs: [URL]
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) ->
        UIDocumentPickerViewController {

        let picker = UIDocumentPickerViewController(forExporting: URLs) //UIDocumentPickerViewController(urls: URLs, in: .moveToService)
        return picker
}

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>){}
}



