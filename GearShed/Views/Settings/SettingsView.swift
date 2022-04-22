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
    //Counters
    @State private var shedsAdded: Int = 0
    @State private var brandsAdded: Int = 0
    @State private var itemsAdded: Int = 0
    @State private var adventuresAdded: Int = 0
    @State private var activitiesAdded: Int = 0
    @State private var diariesAdded: Int = 0
    @State private var pdfUsername: String = ""
    //Sheets
    @State private var showExportSheet: Bool = false
    @State private var showImportSheet: Bool = false
    @State private var showImportAlert: Bool = false
    @State private var showUpgradeSheet: Bool = false
    @State private var showSuccessfulEraseAlert: Bool = false
    
    let test = Prefs.shared
    
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
                preferencesSection
                databaseManagementSection
                IAPSection
                moreInfoSection
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
                        loadData(url: selectedFile)
                        //backupManager.insertFromBackup(url: selectedFile)
                        do {
                            selectedFile.stopAccessingSecurityScopedResource()
                            self.showImportAlert = true
                        }
                    } else {
                        // Handle denied access
                    }
                } catch {
                    // Handle failure.
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
            .alert(isPresented: $showImportAlert) {
                Alert (
                    title: Text("Successfully Loaded Backup"),
                    message: Text(loadedBackupMessage())
                )
            }
            .sheet(isPresented: $showExportSheet) {
                if let data = backUpData() {
                    DocumentPicker(URLs: data)
                }
            }
        }
        .padding(.bottom, 50)
        .navigationViewStyle(.stack)
    }
}

extension SettingsView {
    //General Preferences
    private var pdfUsernameSection: some View {
        HStack {
            Text("PDF Username:")
            TextField("username", text: $pdfUsername)
                .onChange(of: pdfUsername) { newValue in
                    Prefs.shared.pdfUserName = newValue
                }
        }
    }
    private var weightUnitSection: some View {
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
    }
    private var colorSchemeSection: some View {
        //NOT IN USE AT THE MOMENT
        NavigationLink {
            ColorSchemeView()
        } label: {
            Text("Color Scheme")
        }
    }
    private var alternateAppIconSection: some View {
        NavigationLink {
            AlternateIconView()
        } label: {
            Text("Alternate App Icon")
        }
    }
    private var preferencesSection: some View {
        Section {
            pdfUsernameSection
            weightUnitSection
            //colorSchemeSection
            alternateAppIconSection
        } header: {
            Text("Preferences")
        }
    }
    //Database Managemnet
    private var icloudDriveBackupSection: some View {
        Button {
            if gsData.proUser() {
                writeBackupFile()
            } else {
                self.showUpgradeSheet.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "externaldrive.badge.icloud")
                Text("Create iCloud Drive Backup")
            }
        }
    }
    private var offlineBackupSection: some View {
        Button {
            if gsData.proUser() {
                self.showExportSheet.toggle()
            } else {
                self.showUpgradeSheet.toggle()
            }
            
        } label: {
            HStack {
                Image(systemName: "arrow.up.doc.fill")
                Text("Create Offline Backup")
            }
        }
    }
    private var loadBackupSection: some View {
        Button {
            if gsData.proUser() {
                self.showImportSheet.toggle()
                //For testing purposes
                //loadData(url: Bundle.main.url(forResource: "backup", withExtension: "json")!)
            } else {
                self.showUpgradeSheet.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                Text("Load From Backup")
            }
        }
    }
    private var eraseAllContentButton: some View {
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
        /*.alert(isPresented: test.$confirmationAlert) {
            Alert (
                title: Text("Successfully Erased Gear Shed"),
                message: Text("Please restart the app to continue"),
                dismissButton: .default(Text("OK"), action: {
                    Prefs.shared.confirmationAlert = false
                    
                })

            )
        }*/
    }
    private var databaseManagementSection: some View {
        Section {
            // To create a backup file of core data entities to iCloud Drive
            icloudDriveBackupSection
            // To create a backup file of core data entities
            offlineBackupSection
            // To load a backup file into core data
            loadBackupSection
            // To erase all core data entities and reset settings
            eraseAllContentButton
        } header: {
            Text("Database Management")
        }
    }
    //In App Purchases
    private var restorePurchasesSection: some View {
        Button {
            unlockManager.restore()
        } label: {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                Text("Restore Purchases")
            }
        }
    }
    private var unlockProSection: some View {
        Button {
            self.showUpgradeSheet.toggle()
        } label: {
            if gsData.proUser() {
                HStack {
                    Image(systemName: "infinity.circle")
                    Text("Gear Shed Pro Active")
                }
            } else {
                HStack {
                    Image(systemName: "lock.open")
                    Text("Buy Gear Shed Pro")
                }
            }
            
        }
        .sheet(isPresented: $showUpgradeSheet) {
            UnlockView()
        }
    }
    private var tipDeveloperSection: some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                Text("Tip The Developer")
            }
            
        }
    }
    private var IAPSection: some View {
        Section {
            restorePurchasesSection
            unlockProSection
            //tipDeveloperSection
        } header: {
            Text("In App purchases")
        }
    }
    //More Info
    private var aboutSection: some View {
        NavigationLink {
            AboutView()
        } label: {
            HStack {
                Image(systemName: "hand.wave")
                Text("About")
            }
        }
    }
    private var feedbackSection: some View {
        NavigationLink {
            FeedbackView()
        } label: {
            HStack {
                Image(systemName: "message")
                Text("Feedback")
            }
        }
    }
    private var privacyPolicySection: some View {
        NavigationLink {
            PrivacyView()
        } label: {
            HStack {
                Image(systemName: "lock.icloud")
                Text("Privacy Policy & Terms of Service")
            }
        }
    }
    private var moreInfoSection: some View {
        Section {
            aboutSection
            feedbackSection
            privacyPolicySection
        } header: {
            Text("More Information")
        } footer: {
            Text("Version: \(UIApplication.release), Build: \(UIApplication.build)")
        }
    }
    //Title bar
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Settings")
                .formatGreen()
        }
    }
    //Weight Settings Functions
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
    //Backup and Import Functions
    private func loadData(url: URL) {
        // Get a current count on each core data entity
        let currentShedCount = gsData.sheds.count
        let currentBrandCount = gsData.brands.count
        let currentItemCount = gsData.items.count
        let currentAdventuresCount = glData.adventures.count
        let currentActivitiesCount = glData.activities.count
        let currentDiaryCount = gsData.itemDiaries.count
        // Import Backup Data
        backupManager.insertFromBackup(url: url)
        // Find the count of the newly added data using the difference.
        self.shedsAdded = gsData.sheds.count - currentShedCount
        self.brandsAdded = gsData.brands.count - currentBrandCount
        self.itemsAdded = gsData.items.count - currentItemCount
        self.adventuresAdded = glData.adventures.count - currentAdventuresCount
        self.activitiesAdded = glData.activities.count - currentActivitiesCount
        self.diariesAdded = gsData.itemDiaries.count - currentDiaryCount
    }
    private func writeBackupFile() {
        backupManager.backupToiCloudDrive(items: gsData.items, itemImages: gsData.itemImages, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes)
    }
    private func backUpData() -> [URL] {
        var urls = [URL]()
        urls.append(backupManager.writeAsJSON(items: gsData.items, itemImages: gsData.itemImages, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes))
        return urls
    }
    private func loadedBackupMessage() -> String {
        var returnText: String =  ""
        
        if shedsAdded != 0 {
            if shedsAdded == 1 {
                returnText.append(contentsOf: "\(shedsAdded) Shelf, ")
            } else {
                returnText.append(contentsOf: "\(shedsAdded) Shelves, ")
            }
            
        }
        
        if brandsAdded != 0 {
            if brandsAdded == 1 {
                returnText.append(contentsOf: "\(brandsAdded) Brand, ")
            } else {
                returnText.append(contentsOf: "\(brandsAdded) Brands, ")
            }
            
        }
        
        if itemsAdded != 0 {
            if itemsAdded == 1 {
                returnText.append(contentsOf: "\(itemsAdded) Item, ")
            } else {
                returnText.append(contentsOf: "\(itemsAdded) Items, ")
            }
        }
        
        if adventuresAdded != 0 {
            if adventuresAdded == 1 {
                returnText.append(contentsOf: "\(adventuresAdded) Adventure, ")
            } else {
                returnText.append(contentsOf: "\(adventuresAdded) Adventures, ")
            }
        }
        
        if activitiesAdded != 0 {
            if activitiesAdded == 1 {
                returnText.append(contentsOf: "\(activitiesAdded) Activity, ")
            } else {
                returnText.append(contentsOf: "\(activitiesAdded) Activities, ")
            }
        }
        
        if diariesAdded != 0 {
            if diariesAdded == 1 {
                returnText.append(contentsOf: "\(diariesAdded) Gear Diary, ")
            } else {
                returnText.append(contentsOf: "\(diariesAdded) Gear Diaries, ")
            }
        }
        
        var returnTextFinal = returnText.dropLast(2)
        returnTextFinal.append(contentsOf: "- Were Successfully Added To Your Gear Shed")
        
        return String(returnTextFinal)
    }
}


/*
 
 private func loadURL(urls: [URL]) {
     guard let url = urls.first else { return }
     backupManager.insertISBFromBackUp(url: url)
     //backupManager.insertFromBackup(url: url)
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
 
 */
