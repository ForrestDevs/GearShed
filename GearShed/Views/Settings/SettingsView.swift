//
//  SettingsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import Foundation
import CoreData
import SwiftUI
import Combine
import UniformTypeIdentifiers

struct SettingsView: View {
    
    @EnvironmentObject private var unlockManager: UnlockManager
    
    @StateObject private var gsData: GearShedData
    @StateObject private var glData: GearlistData
    @StateObject private var backupManager: BackupManager
    
    @State private var confirmDataHasBeenAdded = false
    @State private var shedsAdded: Int = 0
    @State private var brandsAdded: Int = 0
    @State private var itemsAdded: Int = 0
    
    @State private var changeUnitTap: Bool = false
    
    @State private var showExportSheet: Bool = false
    @State private var showImportSheet: Bool = false
    
    //@State private var stateWeightUnit: String
    //@State private var pdfName: String = Prefs.shared.pdfUserName
    
    //@AppStorage("pdfName", store: .standard) var pdfName = "New User"
    
    
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let backupManager = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: backupManager)
    
        //let SWU = Prefs.shared.weightUnit
        //_stateWeightUnit = State(wrappedValue: SWU)
        
        self.persistentStore = persistentStore
        
    }
    
    private func configureItemMassImpToMetric() {
        for item in gsData.items {
            if item.weight.isEmpty {
                let grams =  Prefs.shared.convertImpToMetric(lbs: item.itemLbs, oz: item.itemOZ)
                item.weight = grams
                item.itemLbs = ""
                item.itemOZ = ""
            } else {
                item.itemLbs = ""
                item.itemOZ = ""
            }
        }
        persistentStore.saveContext()
    }
    
    private func configureItemMassMetricToImp() {
        for item in gsData.items {
            if (item.itemLbs.isEmpty && item.itemOZ.isEmpty) {
                let LbOz = Prefs.shared.convertMetricToImp(grams: item.weight)
                item.itemLbs = LbOz.lbs
                item.itemOZ = LbOz.oz
                item.weight = ""
            } else {
                item.weight = ""
            }
        }
        persistentStore.saveContext()
    }
    
    
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                
                VStack (alignment: .leading, spacing: 25)  {
                    
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("PDF Username")
                            .formatBlackTitle()
                        
                        TextField("PDF Name Feild", text: Prefs.shared.$pdfUserName)
                           // .onReceive(Just(pdfName)) { newValue in
                             //   Prefs.shared.pdfUserName = newValue
                            //}
                    }
                    
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Weight Unit")
                            .formatBlackTitle()
                        
                        HStack (spacing: 5) {
                            Button {
                                //persistentStore.stateUnit = "g"
                                //stateWeightUnit = "g"
                                Prefs.shared.weightUnit = "g"
                                configureItemMassImpToMetric()
                            } label: {
                                HStack {
                                    Text("Grams 'g'")
                                    if (Prefs.shared.weightUnit == "g") {
                                        Image (systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background (
                                    Prefs.shared.weightUnit == "g" ?  RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.theme.green)
                                        .opacity(0.5) : nil
                                )
                            }
                            
                            Button {
                                //persistentStore.stateUnit = "lb + oz"
                                //stateWeightUnit = "lb + oz"
                                Prefs.shared.weightUnit = "lb + oz"
                                configureItemMassMetricToImp()
                            } label: {
                                HStack {
                                    Text("lb + oz")
                                    if (Prefs.shared.weightUnit == "lb + oz") {
                                        Image (systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background (
                                    Prefs.shared.weightUnit == "lb + oz" ?  RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.theme.green)
                                        .opacity(0.5) : nil
                                )

                            }
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.green, lineWidth: 1)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .padding()
                        )
                    }
                    
                    Button {
                        self.showImportSheet.toggle()
                    } label: {
                        Text("Load from back-up")
                            .formatBlackTitle()
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
                            .formatBlackTitle()
                    }
                    
                    Button {
                        unlockManager.restore()
                    } label: {
                        Text("Restore Purchases")
                            .formatBlackTitle()
                    }
                    
                    Spacer()
                    
                }
                .padding()
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



