//
//  SettingsView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine
import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("Weight_Unit", store: .standard) var weightUnit: String = "g"
    @AppStorage("pdfUserName", store: .standard) var pdfUserName: String = "App User"
    @EnvironmentObject private var unlockManager: UnlockManager
    @EnvironmentObject private var detailManager: DetailViewManager
    @StateObject private var gsData: GearShedData
    @StateObject private var glData: GearlistData
    @StateObject private var backupManager: BackupManager
    let persistentStore: PersistentStore
    let gsbType = UTType(exportedAs: "com.GearShed.gsb", conformingTo: .json)
    //Counters
    @State private var shedsAdded: Int = 0
    @State private var brandsAdded: Int = 0
    @State private var itemsAdded: Int = 0
    @State private var adventuresAdded: Int = 0
    @State private var activitiesAdded: Int = 0
    @State private var diariesAdded: Int = 0
    //@State private var pdfUsername: String = ""
    //Sheets
    @State private var showUpgradeSheet: Bool = false
    @State private var showExportSheet: Bool = false
    @State private var showImportSheet: Bool = false
    @State private var showImportSheet_forBase: Bool = false
    //Alerts
    @State private var showSuccessfulEraseAlert: Bool = false
    @State private var showSuccessfullIAPRestore: Bool = false
    @State private var showFailureIAPRestore: Bool = false
    @State private var failureRestoreErrorTitle: String = ""
    @State private var failureRestoreErrorMessage: String = ""
    @State private var showImportAlert: Bool = false
    @State private var importAlertMessage: String = ""
    @State private var importAlertTitle: String = ""
    @State private var showSuccessBackupWrite: Bool = false
    @State private var showFailureBackupWrite: Bool = false
    @State private var BackupWriteAlertTitle: String = ""
    @State private var BackupWriteAlertMessage: String = ""
    @State private var showEraseAllAlert: Bool = false

    init(persistentStore: PersistentStore) {
        let gsData = GearShedData(persistentStore: persistentStore)
        _gsData = StateObject(wrappedValue: gsData)
        let glData = GearlistData(persistentStore: persistentStore)
        _glData = StateObject(wrappedValue: glData)
        let backupManager = BackupManager(persistentStore: persistentStore)
        _backupManager = StateObject(wrappedValue: backupManager)
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
            .fileImporter(isPresented: $showImportSheet_forBase, allowedContentTypes: [gsbType, UTType.json], allowsMultipleSelection: false) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.startAccessingSecurityScopedResource() {
                        // New Function to only add GearShed plus Gearlist with items, no piles, no packs
                        loadBaseGearlistandGearShed(url: selectedFile)
                        do {
                            selectedFile.stopAccessingSecurityScopedResource()
                            importAlertTitle = "Successfully Loaded Backup"
                            importAlertMessage = loadedBackupMessage(type: "Success")
                            self.showImportAlert.toggle()
                        }
                    } else {
                        // Handle denied access
                        importAlertTitle = "Error"
                        importAlertMessage = loadedBackupMessage(type: "Denied")
                        self.showImportAlert.toggle()
                    }
                } catch {
                    // Handle failure.
                    importAlertTitle = "Error"
                    importAlertMessage = loadedBackupMessage(type: "Failure")
                    self.showImportAlert.toggle()
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
//            .fileImporter(isPresented: $showImportSheet, allowedContentTypes: [gsbType, UTType.json], allowsMultipleSelection: false) { result in
//                do {
//                    guard let selectedFile: URL = try result.get().first else { return }
//                    if selectedFile.startAccessingSecurityScopedResource() {
//                        loadData(url: selectedFile)
//                        do {
//                            selectedFile.stopAccessingSecurityScopedResource()
//                            importAlertTitle = "Successfully Loaded Backup"
//                            importAlertMessage = loadedBackupMessage(type: "Success")
//                            self.showImportAlert.toggle()
//                        }
//                    } else {
//                        // Handle denied access
//                        importAlertTitle = "Error"
//                        importAlertMessage = loadedBackupMessage(type: "Denied")
//                        self.showImportAlert.toggle()
//                    }
//                } catch {
//                    // Handle failure.
//                    importAlertTitle = "Error"
//                    importAlertMessage = loadedBackupMessage(type: "Failure")
//                    self.showImportAlert.toggle()
//                    print("Unable to read file contents")
//                    print(error.localizedDescription)
//                }
//            }
        }
        .navigationViewStyle(.stack)
    }
}

extension SettingsView {
    //MARK: General Preferences
    private var pdfUsernameSection: some View {
        HStack {
            Text("PDF Username:")
            TextField("username", text: $pdfUserName)
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
    private var currencyUnitSection: some View {
        NavigationLink {
            CurrencyUnitView()
        } label: {
            Text("Currency Unit")
        }
    }
    private var alternateAppIconSection: some View {
        NavigationLink {
            AlternateIconView()
                .environmentObject(persistentStore)
        } label: {
            Text("Alternate App Icon")
        }
    }
    private var preferencesSection: some View {
        Section {
            pdfUsernameSection
            weightUnitSection
            currencyUnitSection
            alternateAppIconSection
        } header: {
            Text("Preferences")
        }
    }
    //MARK: Database Managemnet
    private var icloudDriveBackupSection: some View {
        Button {
            if gsData.proUser() {
                iCloudBackup()
            } else {
                self.showUpgradeSheet.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "externaldrive.badge.icloud")
                Text("Create iCloud Drive Backup")
            }
        }
        .alert(isPresented: $showSuccessBackupWrite) {
            Alert (
                title: Text("Success"),
                message: Text("Gear Shed has successfully backed up your data to your iCloud folder!")
            )
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
        .sheet(isPresented: $showExportSheet) {
            if let data = offlineBackup() {
                DocumentPicker(URLs: data)
            }
        }
    }
    private var loadBackupSection: some View {
        Button {
            if gsData.proUser() {
                if showImportSheet {
                    // NOTE: Fixes broken fileimporter sheet not resetting on swipedown
                    self.showImportSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.showImportSheet = true
                    }
                } else {
                    self.showImportSheet = true
                }
            } else {
                self.showUpgradeSheet.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                Text("Load From Backup")
            }
        }
        .alert(isPresented: $showImportAlert) {
            Alert (
                title: Text(importAlertTitle),
                message: Text(importAlertMessage)
            )
        }
    }
    private var loadBaseGearlistandGearShedView: some View {
        Button {
            if gsData.proUser() {
                if showImportSheet_forBase {
                    // NOTE: Fixes broken fileimporter sheet not resetting on swipedown
                    self.showImportSheet_forBase = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.showImportSheet_forBase = true
                    }
                } else {
                    self.showImportSheet_forBase = true
                }
            } else {
                self.showUpgradeSheet.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                Text("Load Backup Base Gearlist and GearShed only")
            }
        }
        
    }
    private var eraseAllContentButton: some View {
        Button {
            withAnimation {
                detailManager.content = AnyView(
                    ConfirmEraseView(
                        completion:{self.showEraseAllAlert.toggle()},
                        persistentStore: persistentStore,
                        detailManager: detailManager
                    )
                )
                detailManager.target = .showContent
            }
        } label: {
            HStack {
                Image(systemName: "trash.fill")
                Text("Erase All Content")
            }
            .foregroundColor(.red)
        }
        .alert(isPresented: $showEraseAllAlert) {
            Alert (
                title: Text("Success!"),
                message: Text("All Gear Shed data has been deleted.")
            )
        }
    }
    private var databaseManagementSection: some View {
        Section {
            // To create a backup file of core data entities to iCloud Drive
            icloudDriveBackupSection
            // To create a backup file of core data entities
            offlineBackupSection
            // To load a backup file into core data
            loadBackupSection
            // To load the backup file into core data only Item, Shed, Brand and Base Gearlist
            loadBaseGearlistandGearShedView
            // To erase all core data entities and reset settings
            eraseAllContentButton
        } header: {
            Text("Database Management")
        }
    }
    //MARK: In App Purchases
    private var restorePurchasesSection: some View {
        ZStack {
            //Invisable Rectangle to seperate alerts
            Rectangle()
                .opacity(0)
                .frame(width: 0, height: 0)
                .alert(isPresented: $showFailureIAPRestore) {
                    Alert (
                        title: Text(failureRestoreErrorTitle),
                        message: Text(failureRestoreErrorMessage)
                    )
                }
            Button {
                unlockManager.restorePurchases { result in
                    switch result {
                    case .success(let success):
                        if success {
                            self.showSuccessfullIAPRestore.toggle()
                        } else {
                            failureRestoreErrorTitle = "No Purchases"
                            failureRestoreErrorMessage = """
                                                  There are no purchases to restore, or Gear Shed Unlimited is already active.\n\nIf you feel this is an error, please send us an email.
                                                  """
                            self.showFailureIAPRestore.toggle()
                        }
                    case .failure(let error):
                        failureRestoreErrorTitle = "Error"
                        failureRestoreErrorMessage = error.localizedDescription
                        self.showFailureIAPRestore.toggle()
                    }
                }
                //unlockManager.restore()
            } label: {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Restore Purchases")
                }
            }
            .alert(isPresented: $showSuccessfullIAPRestore) {
                Alert (
                    title: Text("Success"),
                    message: Text("Gear Shed Unlimited has been restored!")
                )
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
                    Text("Gear Shed Unlimited Active")
                }
            } else {
                HStack {
                    Image(systemName: "lock.open")
                    Text("Buy Gear Shed Unlimited")
                }
            }
        }
        .sheet(isPresented: $showUpgradeSheet) {
            UnlockView()
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
    //MARK: More Info
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
    //MARK: Title bar
    private var viewTitle: some ToolbarContent {
        ToolbarItem (placement: .principal) {
            Text("Settings")
                .formatGreen()
        }
    }
    //MARK: Weight Settings Functions
    /// Helper function that converts an items weight from imperial to metric
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
    /// Helper function that converts an items weight from metric to imperial
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
    /// Function to toggle between imperial and metric weight units, and automatically convert all items corrosponding weight
    private func toggleWeightUnit() {
        if weightUnit == "g" {
            weightUnit = "lb + oz"
            configureItemMassMetricToImp()
        } else {
            weightUnit = "g"
            configureItemMassImpToMetric()
        }
    }
    //MARK: Backup and Import Functions
    /// Function to load a JSON backup file and insert entities to the persistent store
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
    
    private func loadBaseGearlistandGearShed(url: URL) {
        // Get a current count on each core data entity
        let currentShedCount = gsData.sheds.count
        let currentBrandCount = gsData.brands.count
        let currentItemCount = gsData.items.count
        let currentAdventuresCount = glData.adventures.count
        let currentActivitiesCount = glData.activities.count
        let currentDiaryCount = gsData.itemDiaries.count
        // Import Backup Data
        backupManager.insertBaseFromBackup(url: url)
        // Find the count of the newly added data using the difference.
        self.shedsAdded = gsData.sheds.count - currentShedCount
        self.brandsAdded = gsData.brands.count - currentBrandCount
        self.itemsAdded = gsData.items.count - currentItemCount
        self.adventuresAdded = glData.adventures.count - currentAdventuresCount
        self.activitiesAdded = glData.activities.count - currentActivitiesCount
        self.diariesAdded = gsData.itemDiaries.count - currentDiaryCount
    }
    
    /// Function to generate a JSON file containing the backup to be sent directly to Gear Shed's iCloud document folder
    private func iCloudBackup() {
//        backupManager.backupToiCloudDrive(items: gsData.items, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes)
        backupManager.backupToiCloudDrive(items: gsData.items, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes) { result in
            switch result {
            case .success(let success):
                if success {
                    self.showSuccessBackupWrite.toggle()
                }
            case .failure(let error):
                BackupWriteAlertTitle = "Error"
                BackupWriteAlertMessage  = error.localizedDescription
                self.showFailureBackupWrite.toggle()
            }
        }
    }
    /// Function to generate a JSON file containing the backup to be sent as a URL to document picker
    private func offlineBackup() -> [URL] {
        var urls = [URL]()
        urls.append(backupManager.writeAsJSON(items: gsData.items, itemDiaries: gsData.itemDiaries, sheds: gsData.sheds, brands: gsData.brands, gearlists: glData.gearlists, piles: glData.listgroups, packs: glData.packingGroups, packingBools: glData.packingBools, activityTypes: glData.activityTypes))
        return urls
    }
    /// Function to generate the message for when a backup file is loaded
    private func loadedBackupMessage(type: String) -> String {
        var returnText: String =  ""
        switch type {
        case "Success":
            if (shedsAdded == 0), (brandsAdded == 0), (itemsAdded == 0), (adventuresAdded == 0), (activitiesAdded == 0), (diariesAdded == 0) {
                returnText = "There is no data to import or all data is already in your Gear Shed."
                return returnText
            } else {
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
                returnTextFinal.append(contentsOf: " - Were Successfully Added To Your Gear Shed")
                return String(returnTextFinal)
            }
        case "Failure":
           return "Failed to load backup, please check the right file was chosen."
        case "Denied":
            return "Failed to open file importer. Access was denied."
        default:
            return ""
        }
    }
}
