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
    
    
    @AppStorage("Weight_Unit", store: .standard) var weightUnit: String = "g"
    
    
    @EnvironmentObject private var unlockManager: UnlockManager
    @EnvironmentObject private var detailManager: DetailViewManager
    
    @StateObject private var gsData: GearShedData
    @StateObject private var glData: GearlistData
    @StateObject private var backupManager: BackupManager
    
    @State private var confirmDataHasBeenAdded = false
    @State private var shedsAdded: Int = 0
    @State private var brandsAdded: Int = 0
    @State private var itemsAdded: Int = 0
    @State private var pdfUsername: String = ""
        
    @State private var showExportSheet: Bool = false
    @State private var showImportSheet: Bool = false
    
    let persistentStore: PersistentStore
    let gsbType = UTType(exportedAs: "com.GearShed.gsb", conformingTo: .json)
    
    init(persistentStore: PersistentStore) {
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        
        let backupManager = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: backupManager)
    
        let pdfUsername = Prefs.shared.pdfUserName
        _pdfUsername = State(wrappedValue: pdfUsername)
        
        self.persistentStore = persistentStore
        
    }
    
    var body: some View {
        NavigationView {
            List {
                // Preferences
                Section {
                    HStack {
                        Text("PDF Username:")
                        TextField("username", text: $pdfUsername)
                            .onChange(of: pdfUsername) { newValue in
                                Prefs.shared.pdfUserName = newValue
                            }
                    }
                    HStack {
                        Text("Weight Unit:")
                        Button {
                            toggleWeightUnit()
                        } label: {
                            HStack {
                                Text("g")
                                    .foregroundColor(weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
                                    .padding(.leading, 10)
                                Image(systemName: "checkmark")
                                    .foregroundColor(weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
                                    .opacity(Prefs.shared.weightUnit == "g" ? 1 : 0)
                                    .padding(.trailing, 5)
                                
                                Text("lbs + oz")
                                    .foregroundColor(weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
                                Image(systemName: "checkmark")
                                    .foregroundColor(weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
                                    .opacity(weightUnit == "lb + oz" ? 1 : 0)
                            }
                        }
                    }
                    
                    /*HStack {
                        Text("Weight Unit:")
                        Button {
                            toggleWeightUnit()
                        } label: {
                            HStack {
                                Text("g")
                                    .foregroundColor(Prefs.shared.weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
                                    .padding(.leading, 10)
                                Image(systemName: "checkmark")
                                    .foregroundColor(Prefs.shared.weightUnit == "g" ? Color.theme.accent : Color.theme.promptText)
                                    .opacity(Prefs.shared.weightUnit == "g" ? 1 : 0)
                                    .padding(.trailing, 5)
                                
                                Text("lbs + oz")
                                    .foregroundColor(Prefs.shared.weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
                                Image(systemName: "checkmark")
                                    .foregroundColor(Prefs.shared.weightUnit == "lb + oz" ? Color.theme.accent : Color.theme.promptText)
                                    .opacity(Prefs.shared.weightUnit == "lb + oz" ? 1 : 0)
                            }
                        }
                    }*/
                    
                    NavigationLink {
                        ColorSchemeView()
                    } label: {
                        Text("Color Scheme")
                    }
                    
                    NavigationLink {
                        AlternateIconView()
                    } label: {
                        Text("Alternate App Icon")
                    }
                } header: {
                    Text("Preferences")
                }
                // Database Management
                Section {
                    // To create a backup file of core data entities
                    Button {
                        writeBackupFile()
                        

                        //self.showExportSheet.toggle()
                        //print(NSHomeDirectory())
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.doc.fill")
                            Text("Create Offline Backup")
                        }
                    }
                    // To load a backup file into core data
                    Button {
                        self.showImportSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.doc.fill")
                            Text("Load From Backup")
                        }
                    }
                    // To erase all core data entities and reset settings
                    Button {
                        withAnimation {
                            detailManager.target = .showConfirmEraseView
                        }
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Erase All Content")
                        }
                        .foregroundColor(.red)
                    }
                    
                } header: {
                    Text("Database Management")
                }
                // In App Purchases
                Section {
                    Button {
                        unlockManager.restore()
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("Restore Purchases")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "lock.open")
                            Text("Unlock Pro")
                        }
                        
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("Tip The Developer")
                        }
                        
                    }
                    
                } header: {
                    Text("In App purchases")
                }
                // More Information
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            Image(systemName: "hand.wave")
                            Text("About")
                        }
                    }
                    
                    NavigationLink {
                        FeedbackView()
                    } label: {
                        HStack {
                            Image(systemName: "message")
                            Text("Feedback")
                        }
                    }
                    
                    NavigationLink {
                        PrivacyView()
                    } label: {
                        HStack {
                            Image(systemName: "lock.icloud")
                            Text("Privacy Policy & Terms of Service")
                        }
                    }
                } header: {
                    Text("More Information")
                } footer: {
                    Text("Version: \(UIApplication.release), Build: \(UIApplication.build)")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                viewTitle
            }
            .fileImporter(isPresented: $showImportSheet, allowedContentTypes: [gsbType, UTType.json], allowsMultipleSelection: false) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.startAccessingSecurityScopedResource() {
                        //backupManager.insertISBFromBackUp(url: selectedFile)
                        backupManager.insertFromBackup(url: selectedFile)
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
            .sheet(isPresented: $showExportSheet) {
                if let data = backUpData() {
                    DocumentPicker(URLs: data)
                }
            }
            .padding(.bottom, 50)
        }
        .navigationViewStyle(.stack)
    }
    
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Settings")
                .formatGreen()
        }
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
    
    
    private func toggleWeightUnit() {
        if weightUnit == "g" {
            weightUnit = "lb + oz"
            configureItemMassMetricToImp()
        } else {
            weightUnit = "g"
            configureItemMassImpToMetric()
        }
    }
    
    /*private func toggleWeightUnit() {
        if Prefs.shared.weightUnit == "g" {
            Prefs.shared.weightUnit = "lb + oz"
            configureItemMassMetricToImp()
        } else {
            Prefs.shared.weightUnit = "g"
            configureItemMassImpToMetric()
        }
    }*/
    
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
    
    private func writeBackupFile() {
        backupManager.backupToiCloudDrive(items: gsData.items, itemImages: gsData.itemImages, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes)
    }
    
    private func backUpData() -> [URL] {
        var urls = [URL]()
        urls.append(backupManager.writeAsJSON(items: gsData.items, itemImages: gsData.itemImages, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes))
        return urls
    }
}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}



/*NavigationView {
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
.navigationViewStyle(.stack)*/
