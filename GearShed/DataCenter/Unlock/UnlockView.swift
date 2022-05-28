//
//  UnlockView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  Copyright © 2022 All rights reserved.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    @State private var showSuccessfullIAPRestore: Bool = false
    @State private var showFailureIAPRestore: Bool = false
    @State private var failureRestoreErrorTitle: String = ""
    @State private var failureRestoreErrorMessage: String = ""
    @State private var showIAPActiveAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image(systemName: "infinity.circle")
                    .resizable()
                    .foregroundColor(Color.theme.green)
                    .frame(width: 50, height: 50)
                Text("Upgrade to Gear Shed Unlimited!")
                    .formatIAPTitle()
                Text("With the free version, you can add up to 30 pieces of gear and create one gearlist.")
                    .formatBlackSmall()
                    .multilineTextAlignment(.center)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 350, height: 200)
                        .foregroundColor(.theme.green)
                        .opacity(0.3)
                
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Purchase Gear Shed Unlimited To Get: ")
                            .formatIAPHeader()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Add Unlimited Gear")
                                .formatIAPItems()
                        }
                        .foregroundColor(.theme.green)
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Create Unlimited Gear Lists")
                                .formatIAPItems()
                        }
                        .foregroundColor(.theme.green)
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Backup your Gear Shed")
                                .formatIAPItems()
                        }
                        .foregroundColor(.theme.green)
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Alternate App Icons")
                                .formatIAPItems()
                        }
                        .foregroundColor(.theme.green)
                    }
                    .padding()
                }
                VStack(alignment: .leading, spacing: 15) {
                    Text("By spending what you would on two coffees you are supporting the devloper and helping to encourage future updates and new features. Your feedback is always welcomed.")
                        .formatBlackSmall()
                    Text("If you already bought this upgrade on another device, please press Restore Purchases below.")
                        .formatBlackSmall()
                }
                VStack {
                    switch unlockManager.requestState {
                    case .loaded(let product):
                        Button {
                            unlockManager.buy(product: product)
                        } label: {
                          HStack {
                              Image(systemName: "bag.fill")
                                  .foregroundColor(.theme.green)
                              Text("Buy: \(product.localizedPrice)")
                                  .formatGreenTitle()
                          }
                          .padding()
                          .background(
                              RoundedRectangle(cornerRadius: 15)
                                  .foregroundColor(.theme.green)
                                  .opacity(0.3)
                          )
                        }
                    case .failed(_):
                        Text("Sorry, there was an error loading the store. Please try again later.")
                            .formatGreen()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.theme.green)
                                    .opacity(0.3)
                            )
                    case .loading:
                        ProgressView("Loading...")
                            .foregroundColor(.theme.green)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.theme.green)
                                    .opacity(0.3)
                            )
                    case .purchased:
                        Button {
                            self.showIAPActiveAlert.toggle()
                        } label: {
                              HStack {
                                  Image(systemName: "infinity.circle")
                                      .foregroundColor(.theme.green)
                                  Text("Gear Shed Unlimited Active")
                                      .formatGreenTitle()
                               }
                               .padding()
                               .background(
                                  RoundedRectangle(cornerRadius: 15)
                                      .foregroundColor(.theme.green)
                                      .opacity(0.3)
                               )
                        }
                        .alert(isPresented: $showIAPActiveAlert) {
                            Alert(
                                title: Text("Already Purchased"),
                                message: Text("Gear Shed Unlimited is currently active"),
                                dismissButton: .default(Text("Ok")) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    case .deferred:
                        Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
                            .formatGreen()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.theme.green)
                                    .opacity(0.3)
                            )
                    }
                }
                HStack {
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
                    } label: {
                        Text("Restore Purchases")
                        .formatIAPFooter()
                    }
                    .alert(isPresented: $showFailureIAPRestore) {
                        Alert (
                            title: Text(failureRestoreErrorTitle),
                            message: Text(failureRestoreErrorMessage)
                        )
                    }
                    Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/privacy.html")!) {
                        Text("Privacy Policy")
                            .formatIAPFooter()
                    }
                    .alert(isPresented: $showSuccessfullIAPRestore) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Gear Shed Unlimited has been restored!"),
                            dismissButton: .default(Text("Ok")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    Link(destination: URL(string: "https://pages.flycricket.io/gear-shed/terms.html")!) {
                        Text("Terms of Service")
                            .formatIAPFooter()
                    }
                }
            }
            .padding()
            .padding(.top, -30)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

//            .onReceive(unlockManager.$requestState) { value in
//                if case .purchased = value {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            }

// var body: some View {
//        VStack {
//            switch unlockManager.requestState {
//            case .loaded(let product):
//                ProductView(product: product, type: "Buy")
//            case .failed(_):
//                Text("Sorry, there was an error loading the store. Please try again later.")
//            case .loading:
//                ProgressView("Loading…")
//            case .purchased:
//                ProductView(product: nil, type: "Purchased")
//            case .deferred:
//                Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
//            }
//        }
//        .padding()
//
//    }
